# F1 — Reconexión con Supabase: unificar dominio de usuario, RLS y realtime

> **Estado:** borrador para aprobación del usuario.
> **Fase:** F1 (reconexión + cimientos).
> **Requiere aprobación del usuario:** instalar `zod`; aplicar la migración con `pnpm dlx supabase db reset`.

---

## 1. Contexto

El chat está deshabilitado (`MessagesModule` comentado en `app/page.tsx`) y el código a medio migrar no funciona contra la base real. Causas medidas en el repositorio:

1. **Dos dominios de usuario en conflicto.** `features/users/actions.ts` opera sobre la tabla `users` (que existe, con RLS + policies propias), pero `services/profile.ts` consulta la tabla `profiles`, **que no existe**. La decisión 2026-10-07 (ver `MEMORY.md`) ya resolvió la contradicción: una sola tabla `profiles`.
2. **Inserts rotos.** `createMessage` (`services/messages.ts:56-61`) inserta `{ content, author: user?.email }`; la columna `author` no existe — la tabla tiene `user_id` → todos los inserts fallan.
3. **`messages` sin policies.** RLS habilitado pero **cero policies**: el acceso está bloqueado para todos los roles, incluso el dueño de cada mensaje. `deleteMessage` además borra por `id` sin restricción alguna de autor.
4. **Realtime incompleto.** `messages` ya está en `supabase_realtime` (migración `20261008015400`), pero falta `REPLICA IDENTITY FULL`: los eventos `DELETE`/`UPDATE` llegarían con `old_record` incompleto o nulo.
5. **Falta el bucket `profiles_avatars`**, que `app/profile/helps.ts` referencia para avatares.
6. **Deuda de tipado.** `services/profile.ts` define `interface Profile` a mano y hace `throw "…"` (string); `features/users/types.ts` redeclara `User` a mano. La regla dura 1 exige Zod como contrato con `z.infer`.

Objetivo de F1: una sola tabla `profiles` funcional, `messages` con RLS correcto y realtime completo, acciones de dominio en `features/profiles/` y `features/chat/`, contrato Zod, y sin `throw` de strings. Esto desbloquea F2 (migrar `services/` + `components/`), F3 (restaurar chat y verificar realtime end-to-end) y los 4 errores de `tsc` de `lib/supabase/client.ts`, que dependen del estado de `features/`.

Se resuelven los ítems de deuda `[F1]` de `MEMORY.md`: tabla `profiles` inexistente, insert roto (`author`), RLS sin policies, realtime incompleto, trigger `handle_new_user`, y Zod no instalado.

---

## 2. Requisitos

- **REQ-1.** Existe una única tabla `profiles` en el esquema público que unifica los datos de `users`, conservando `id`, `created_at`, `email` y el valor de `user_name` (conservado como `username`). `profiles` contiene también `full_name` y `avatar_url` (nuevas, nullable).
- **REQ-2.** La tabla `users` queda eliminada; no queda código, migración aplicada ni referencia que la consulte.
- **REQ-3.** `profiles` tiene RLS habilitado y policies que permiten: (a) SELECT de propio registro y de todos los perfiles (listado público), (b) UPDATE solo del propio registro (con `avatar_url` y `full_name` editables), (c) INSERT del propio registro como *fallback* si no existe.
- **REQ-4.** `messages` tiene RLS habilitado y policies que permiten: (a) SELECT de todos los mensajes (chat de un solo canal público), (b) INSERT solo como usuario autenticado con `user_id = auth.uid()`, (c) UPDATE del propio mensaje (contenido) con `user_id = auth.uid()`, (d) DELETE **solo del propio mensaje** — se restringe el `deleteMessage` genérico del código actual y se justifica abajo.
- **REQ-5.** `messages` tiene `REPLICA IDENTITY FULL` para que los payloads de `DELETE`/`UPDATE` lleguen completos en realtime.
- **REQ-6.** El trigger `handle_new_user` inserta en `profiles` (no en `users`) al alta de `auth.users`.
- **REQ-7.** Existe un bucket `profiles_avatars` en Supabase Storage con **lectura pública** y **escritura solo del dueño**, para subir y servir avatares sin exponer la URL de subida a terceros.
- **REQ-8.** `features/profiles/` reemplaza `services/profile.ts` y `features/users/`: expone `getProfile`, `listProfiles`, `updateProfile`, `logOut` como API pública en `index.ts`, con acceso a datos solo en `actions.ts`.
- **REQ-9.** `features/chat/` reemplaza `services/messages.ts`: expone `listMessages`, `getMessagesRange`, `createMessage`, `deleteMessage` con acceso a datos en `actions.ts`; `createMessage` escribe `user_id` (corrección de la columna `author`).
- **REQ-10.** Los esquemas Zod de `profiles` y `chat` viven en `features/<dominio>/schemas.ts`; los tipos se derivan con `z.infer`. No hay interfaces a mano fuera de `lib/supabase/database.types.ts`.
- **REQ-11.** El dominio `chat` importa el perfil del autor **solo** a través del `index.ts` de `features/profiles/` (excepción acordada `chat → profiles`).
- **REQ-12.** Toda la capa de dominios lanza errores tipados (`extends Error`); queda prohibido `throw` de strings en `features/**` y `services/**` eliminados.
- **REQ-13.** El hook `useMessagesRealtime` de `features/chat/hooks/` se suscribe a realtime de `messages` (canal `postgres_changes`) y expone los eventos `INSERT`/`UPDATE`/`DELETE`. Queda fuera de componentes de UI (regla dura 8).
- **REQ-14.** La migración se agrega como archivo **nuevo** en `supabase/migrations/` (nunca editando `20261008015400_estado_actual.sql`) y se aplica **solo** con `pnpm dlx supabase db reset` a cargo del usuario.
- **REQ-15.** Tras la migración aplicada se regenera `lib/supabase/database.types.ts` con `pnpm run gen:types` (script de `package.json`; escribe UTF-8; el redirecionamiento `>` directo en PowerShell produce UTF-16 y rompe ESLint).
- **REQ-16.** Queda prohibido `throw "texto"` a partir de este spec.

---

## 3. Modelo de datos

### 3.1 Zod — `features/profiles/schemas.ts`

> **Requiere aprobación del usuario** para instalar `zod` (`pnpm add zod`). Hasta entonces las specs son declarativas: el implementer no crea estos archivos con `z` sino `unknown` hasta que se apruebe.

```ts
// features/profiles/schemas.ts
import { z } from "zod";

// Perfil completo (row de `profiles`).
// `id` coincide con `auth.users.id` (1:1), por eso el RLS usa `id = auth.uid()`.
export const profileSchema = z.object({
  id: z.string().uuid(),
  created_at: z.string().datetime(),
  email: z.string().email().nullish(),
  username: z.string().min(1).max(32).nullish(),
  full_name: z.string().max(120).nullish(),
  avatar_url: z.string().url().nullish(),
});

export type Profile = z.infer<typeof profileSchema>;

// Input de alta (usado solo por el trigger; el cliente no inserta).
export const profileInsertSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email().optional(),
});

// Input de actualización permitida al usuario (solo campos que el RLS permite modificar).
// `id` queda fuera: el RLS lo fija a `auth.uid()` vía `USING`/`WITH CHECK`.
// `email` queda fuera: no se edita en esta fase (ver P1).
export const profileUpdateSchema = z.object({
  username: z.string().min(1).max(32).optional(),
  full_name: z.string().max(120).optional().nullable(),
  avatar_url: z.string().url().optional().nullable(),
});

export type ProfileUpdate = z.infer<typeof profileUpdateSchema>;

// Autor de un mensaje: subconjunto del perfil expuesto al resto del chat.
// Se sirve únicamente a través de `index.ts` de este dominio (excepción `chat → profiles`).
export const messageAuthorSchema = z.object({
  id: z.string().uuid(),
  username: z.string().nullish(),
  avatar_url: z.string().url().nullish(),
});

export type MessageAuthor = z.infer<typeof messageAuthorSchema>;
```

### 3.2 Zod — `features/chat/schemas.ts`

```ts
// features/chat/schemas.ts
import { z } from "zod";
import { messageAuthorSchema, type MessageAuthor } from "../profiles";

// Mensaje puro (row de `messages`). El autor se une en la capa de presentación,
// nunca se persiste una columna duplicada por aquí.
export const messageSchema = z.object({
  id: z.string().uuid(),
  created_at: z.string().datetime(),
  content: z.string().min(1),
  user_id: z.string().uuid().nullish(),
});

export type Message = z.infer<typeof messageSchema>;

// Mensaje con autor (forma de mostrar): `messageSchema` + `author` (del dominio `profiles`).
export const messageWithAuthorSchema = z
  .object({ author: messageAuthorSchema.nullish() })
  .merge(messageSchema);

export type MessageWithAuthor = z.infer<typeof messageWithAuthorSchema>;

// Input de alta: la columna `user_id` toma valor por defecto via trigger/RLS,
// pero se la permite explícitamente para dejar el contrato de dominio claro.
export const messageInsertSchema = z.object({
  content: z.string().min(1).max(4000),
});

export type MessageInsert = z.infer<typeof messageInsertSchema>;

// Payload realtime de `postgres_changes` de `messages`.
// En eventos `INSERT` llega `types='INSERT'` con `new_record` y `old_record: null`.
// En `UPDATE`/`DELETE` llegan ambos; por eso pedimos `REPLICA IDENTITY FULL` (REQ-5).
export type RealtimeEvent<T extends { type: "INSERT" | "UPDATE" | "DELETE" }> = T extends { type: "INSERT" }
  ? { type: "INSERT"; new_record: Message; old_record: null }
  : T extends { type: "UPDATE" }
    ? { type: "UPDATE"; new_record: Message; old_record: Message }
    : { type: "DELETE"; new_record: null; old_record: Message };
```

### 3.3 SQL — migración nueva

> **Intención declarada, no dump.** El archivo real lo crea `db-supabase` con `pnpm dlx supabase migration new <nombre>` tras la aprobación de esta spec.
> **Requiere aprobación del usuario** para aplicar: `pnpm dlx supabase db reset`.

```sql
-- 1) Nueva tabla `profiles` (unifica `users`; convención estándar de Supabase).
CREATE TABLE public.profiles (
  id          uuid        PRIMARY KEY,                  -- = auth.users.id (1:1)
  created_at  timestamptz NOT NULL DEFAULT now(),
  email       text,
  username    text,                                     -- rename de `users.user_name`
  full_name   text,
  avatar_url  text
);

-- 2) Migrar los datos existentes de `users` a `profiles`.
INSERT INTO public.profiles (id, created_at, email, username)
SELECT id, created_at, email, user_name
FROM   public.users;

-- `messages.user_id` apunta a `profiles.id` (mismo uuid que `auth.users.id`),
-- así que la FK es opcional en esta fase; se declara para documentar la relación.
ALTER TABLE public.messages
  ADD CONSTRAINT messages_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles (id)
  ON DELETE SET NULL;

-- 3) Borrar la tabla antigua.
DROP TABLE public.users;

-- 4) RLS de `profiles`.
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 4a) Ver el propio perfil.
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT TO authenticated
  USING (id = auth.uid());

-- 4b) Ver todos los perfiles (listado público del chat).
CREATE POLICY "profiles_select_public" ON public.profiles
  FOR SELECT TO authenticated, anon
  USING (true);

-- 4c) Actualizar solo el propio perfil (los campos son editables por la UI).
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE TO authenticated
  USING    (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- 4d) Insertar solo el propio perfil (protege contra el caso "trigger aún no corrió").
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

-- 5) RLS de `messages` (falta total hoy).
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 5a) Ver todos los mensajes (chat público de un solo canal).
CREATE POLICY "messages_select_all" ON public.messages
  FOR SELECT TO authenticated, anon
  USING (true);

-- 5b) Insertar como el propio usuario autenticado.
CREATE POLICY "messages_insert_own" ON public.messages
  FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

-- 5c) Actualizar solo el propio mensaje (content; no el timestamp y no el id).
CREATE POLICY "messages_update_own" ON public.messages
  FOR UPDATE TO authenticated
  USING    (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- 5d) BORRADO PROPIO.
-- El código actual (`services/messages.ts:39-48`) deja borrar cualquier mensaje por
-- `id`, sin verificación de autor. Con RLS la política debe ser restrictiva:
-- el usuario solo borra lo que escribió. Si más adelante se necesita un admin o
-- moderador, se agrega una política adicional con `TO authenticated` y una check
-- de rol (fuera de alcance, ver P4).
CREATE POLICY "messages_delete_own" ON public.messages
  FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- 6) Realtime: `messages` ya está en `supabase_realtime` (migración anterior 20261008…);
--    solo falta esta línea para payloads DELETE/UPDATE completos.
ALTER TABLE public.messages REPLICA IDENTITY FULL;

-- 7) Trigger de alta: ahora inserta en `profiles`.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (NEW.id, NEW.email)
  ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = 'public';

-- Trigger ya existe sobre auth.users (migración anterior). No se duplica.

-- 8) Bucket de avatares.
--    Supabase CLI no crea buckets en migraciones (son runtime), así que esta
--    línea es *intención declarada*: el usuario (o un script aprobado) crea el
--    bucket una sola vez contra el stack local. Ver P2.
-- CREADO FUERA DE LA MIGRACIÓN:
--   bucket: profiles_avatars
--   public: TRUE (lectura pública para servir la URL en el chat)
--   políticas:
--     * upload / delete: TO authenticated, WITH CHECK / USING (storage.foldername(name)[1] = auth.uid()::text)
--     * read: TO authenticated, anon (lectura pública)
```

**Justificación de las decisiones SQL:**

- **`profiles.id = auth.uid()`** (1:1) en vez de una FK a `auth.users`: la convención estándar de Supabase; `handle_new_user` ya lo asume y las policies usan `auth.uid()` en vez de `auth.users.id`.
- **`messages_select_all`**: el chat no tiene el concepto de "conversación privada" ni "hilo"; es un solo canal público. Si más adelante se necesitan hilos por par, se agrega una tabla `conversations` (fuera de alcance).
- **`messages_update_own`**: hoy no hay UI de edición (`services/messages.ts` no exporta `updateMessage`). Se define la policy por paridad y para que el RLS esté completo si un futuro feature la incorpora; si se decide que la edición no es un caso de uso de F1, se elimina sin romper nada.
- **`messages_delete_own`**: el código actual (`deleteMessage`) es genérico; la spec **lo restringe al autor** porque con RLS no puede quedar "cualquiera borra cualquier mensaje" y porque es el comportamiento esperado de un chat. Si el producto quiere un modo moderador, es una feature nueva.
- **`ON CONFLICT ... DO UPDATE` en el trigger**: el trigger `handle_new_user` corrió contra la base anterior (la tabla `users` tiene filas). Al migrar, la tabla `profiles` ya tiene la fila; el trigger re-corriendo tras un `supabase auth` futuro inserta otra vez. El `ON CONFLICT` lo hace idempotente.

---

## 4. Archivos afectados (propuesta)

> **El orquestador convierte esta tabla en el plan que el usuario aprueba.** Cada fila es una tarea candidata del `implementer` / `db-supabase`.

### Crear

| Archivo | Intención |
| --- | --- |
| `supabase/migrations/2026MMDD_HHMMSS_reconexion_profiles_messages.sql` | Migración nueva (ver §3.3). Creada con `pnpm dlx supabase migration new`. |
| `features/profiles/schemas.ts` | Contratos Zod de perfil (ver §3.1). |
| `features/profiles/types.ts` | Tipos derivados: `export type { Profile as Profile } from "./schemas";` (solo `export type` derivado, sin interfaces). |
| `features/profiles/actions.ts` | `getProfile`, `listProfiles`, `updateProfile`, `logOut` (server actions, acceso a datos solo aquí). Con errores tipados. |
| `features/profiles/index.ts` | API pública: `{ getProfile, listProfiles, updateProfile, logOut, type Profile, type ProfileUpdate, type MessageAuthor, getAuthor }`. `getAuthor(id)` es la función pública que `chat` importa (excepción acordada `chat → profiles`). |
| `features/profiles/hooks/useProfile.ts` | *(opcional, solo si F2 lo pide)* hook del perfil propio. En F1 no se crea: los componentes de perfil actuales consumen `getUserInfo` vía server action. |
| `features/profiles/components/` | *(opcional, F2)* Se decide en F2. F1 no crea componentes aquí. |
| `features/chat/schemas.ts` | Contratos Zod de chat (ver §3.2). |
| `features/chat/types.ts` | Tipos derivados de mensajes y payloads realtime (`z.infer` / union de payloads). |
| `features/chat/actions.ts` | `listMessages`, `getMessagesRange`, `createMessage` (corrección `author` → `user_id`), `deleteMessage`. Server actions; errores tipados. |
| `features/chat/index.ts` | API pública: `{ listMessages, getMessagesRange, createMessage, deleteMessage, type Message, type MessageWithAuthor, type MessageInsert, useMessagesRealtime }` (solo el hook `useMessagesRealtime`; un eventual hook de estado combinado se decide en F2/F3, ver §4). |
| `features/chat/hooks/useMessagesRealtime.ts` | Hook que se suscribe a `postgres_changes` de `messages` (canal `messages_channel` o `postgres_changes:schema=public:table=messages`) y expone `add`, `update`, `remove`. |
| `features/chat/hooks/useMessages.ts` (estado combinado, opcional) | *(opcional)* hook de estado que combina la llamada inicial con los eventos realtime emitidos por `useMessagesRealtime`; se decide en F2/F3 junto con la UI. F1 solo crea `useMessagesRealtime`. |
| `lib/errors.ts` *(o en cada dominio)* | Clase `DomainError extends Error` para estandarizar errores tipados (REQ-12). Se acuerda con el orquestador antes de crear. |

### Modificar

| Archivo | Intención |
| --- | --- |
| `app/page.tsx` | Descomentar el `MessagesModule` o sustituirlo por el componente nuevo de `features/chat/` cuando exista (F3); en F1 se limita a ajustar imports si cambian de ubicación. |
| `app/profile/page.tsx` (o la ruta que consume `services/profile.ts`) | Cambiar imports de `services/profile.ts` a `features/profiles/index.ts`. |
| `app/profile/helps.ts` | Pasar de `createClient` local a `features/profiles/actions.ts` (sube el avatar y devuelve la URL) o crear una action dedicada; **eliminar `throw "Error al subir la imagen"`**. |
| `components/messagesModule.tsx` | Consumir `features/chat/index.ts` (acciones + tipos) en vez de `services/messages.ts`; eliminar la `interface Message` duplicada (deuda `[F2]`). |

### Eliminar

| Archivo | Motivo |
| --- | --- |
| `services/profile.ts` | Reemplazado por `features/profiles/actions.ts`. |
| `services/messages.ts` | Reemplazado por `features/chat/actions.ts`. |
| `features/users/` (carpeta completa: `actions.ts`, `types.ts`, `index.ts`) | Unificado en `features/profiles/`. |

**No se modifica (intencional):**

- `supabase/migrations/20261008015400_estado_actual.sql` — migración ya aplicada; **inmutable** (regla dura 5).
- `lib/supabase/database.types.ts` — **solo** se regenera con `pnpm run gen:types` **después** de aplicar la migración nueva (el script de `package.json` escribe UTF-8; el redirecionamiento `>` directo en PowerShell produce UTF-16 y rompe ESLint).
- `.opencode/agents/*.md`, `opencode.json` — fuera de esta feature.
- `components/testChannel.tsx`, `lib/supabase/client.ts`, `services/authClient.ts`, `app/login/page.tsx` — la deuda de `tsc` por `supabaseClient` está **saldada** (2026-10-14): en esos archivos `supabaseClient` pasó a `createClient()` y `payload` quedó tipado. No queda pendiente. *(Ver P5.)*

### Dependencias entre dominios

- `features/chat/index.ts` **importa** de `features/profiles/index.ts` solo `getAuthor` / `MessageAuthor` (excepción acordada `chat → profiles`, AGENTS.md §4).
- Ningún dominio de F1 importa `services/*`.
- Ningún archivo fuera de `features/**`, `docs/specs/**` o `supabase/migrations/**` lo toca `implementer` en F1; los files en `app/`, `components/`, `lib/errors.ts` los toca el orquestador (que tiene `app/**` y `lib/**` en su lista de permisos) o el `implementer` con la arena ampliada (decision 2026-10-09 en `MEMORY.md`).

---

## 5. Criterios de aceptación

| ID | Ligado a | Qué debe pasar | Cómo se comprueba |
| --- | --- | --- | --- |
| CA-1 | REQ-1, REQ-2 | Tras aplicar la migración nueva, hay una única tabla `profiles` en `public` (con `id, created_at, email, username, full_name, avatar_url`) y la tabla `users` no existe. | `pnpm dlx supabase db reset` exit 0. Luego `psql -c "\dt public.*"` o `SELECT to_regclass('public.users') IS NULL, to_regclass('public.profiles') IS NOT NULL;` → `(f, t)`. |
| CA-2 | REQ-1, REQ-3 | Los datos de `users` (id, email, user_name) existen en `profiles` con username intacto, `full_name` y `avatar_url` NULL. | `SELECT id, email, username, full_name, avatar_url FROM public.profiles LIMIT 10;` → las filas coinciden con las de `users` previas (comparar antes/después del `db reset`). |
| CA-3 | REQ-3 | Un usuario autenticado puede SELECT/INSERT/UPDATE su propio perfil; SELECT de otros perfiles también funciona. | Prueba manual: logueado como `userA`, `getProfile()` devuelve su perfil; `listProfiles()` incluye el de `userA` y el de `userB`; `updateProfile({ username: "nuevo" })` actualiza solo al de `userA`. |
| CA-4 | REQ-4 | Un usuario puede SELECT todos los mensajes; INSERT con `user_id = auth.uid()`; UPDATE/DELETE solo de sus propios mensajes; DELETE de un mensaje de otro no borra nada (retorna 0 filas). | Prueba manual con 2 usuarios (`A` y `B`): `A` crea 2 mensajes; `B` intenta `deleteMessage(idDeAMsg)` → `success: false` o `rows: 0`; `A` borra el propio → exit. |
| CA-5 | REQ-5 | En realtime, los eventos `UPDATE` y `DELETE` de `messages` traen `old_record` completo. | Abrir 2 sesiones del chat; `A` edita un mensaje; `B` ve el `old_record` con `id`, `user_id`, `content`, `created_at` en el hook. |
| CA-6 | REQ-6 | Al crear un usuario nuevo vía Supabase Auth, `profiles` recibe la fila idempotentemente. | `psql -c "SELECT count(*) FROM auth.users"` antes y después del login de un `email` nuevo; `SELECT from profiles WHERE id = <nuevo id>` → 1 fila. Repetir el login → sigue en 1 fila (idempotentía del `ON CONFLICT`). |
| CA-7 | REQ-7 | El bucket `profiles_avatars` existe, `public: true`; subida de `A` es visible para `B` por URL pública y no puede ser borrada por `B`. | `pnpm dlx supabase storage buckets list` → aparece `profiles_avatars`; prueba manual upload + `getPublicUrl`. |
| CA-8 | REQ-8, REQ-10, REQ-12 | `features/profiles/` existe con `schemas.ts`, `types.ts`, `actions.ts`, `index.ts`; no hay `interface ... { ... }` a mano en `features/profiles/**` (salvo `types.ts` que solo hace `export type`); ningún `throw "texto"`; los tipos de retorno vienen de `z.infer`. | `pnpm exec tsc --noEmit` exit 0. `pnpm lint` exit 0. `Select-String -Path "features/profiles/**" -Pattern 'interface\s+\w+'` → sin matches. `Select-String -Path "features/**" -Pattern 'throw\s*"'` → sin matches. |
| CA-9 | REQ-4d, REQ-9, REQ-10, REQ-12 | `features/chat/` existe; `createMessage` inserta `{ content }` y deja `user_id` a `auth.uid()` (no escribe `author`); `deleteMessage` ejecuta `DELETE ... WHERE id = <id>` (el `WHERE` no incluye `user_id`); la restricción de autor —borrar solo el propio mensaje, 0 filas si es de otro— la garantiza la policy `messages_delete_own` de `messages`, no la consulta de `actions.ts`; tipos y payloads realtime de `z.infer`. | `pnpm exec tsc --noEmit` exit 0. `Select-String -Path "features/chat/**" -Pattern '\bauthor\b'` → 0 matches. `SELECT polname, polcmd, pg_get_expr(polqual, oid) FROM pg_policies WHERE tablename = 'messages' AND polname = 'messages_delete_own';` → `user_id = auth.uid()`. Prueba manual con 2 usuarios: `B` borra el `id` de `A` → 0 filas; `A` borra el propio → exit (igual que CA-4). |
| CA-10 | REQ-11 | `features/chat/schemas.ts` y `actions.ts` importan `MessageAuthor` / `getAuthor` **solo** desde `features/profiles/index.ts`, no de `features/profiles/actions` o `schemas` directamente. | `grep -R "from \"\.\./profiles\"" features/chat/` → solo `index.ts` importado, no submódulos. |
| CA-11 | REQ-13 | `features/chat/hooks/useMessagesRealtime.ts` existe y se suscribe a `supabase.channel("…").on("postgres_changes", { schema: "public", table: "messages", event: "*" }, …)`; no es un componente de UI. | `grep -R "useRealtime\|supabase.channel" features/chat/hooks/` → match; `grep -R "useMessagesRealtime" features/chat/hooks/*.tsx` → sin match (`hooks` solo `.ts`). |
| CA-12 | REQ-14, REQ-15 | Solo existe **una** migración nueva (`*_reconexion_*` o similar) en `supabase/migrations/`; `20261008015400_estado_actual.sql` no fue modificado (`git diff` vacío sobre ese archivo). Después de `pnpm dlx supabase db reset` y `pnpm run gen:types`, `lib/supabase/database.types.ts` declara `profiles` y `messages` con `REPLICA IDENTITY FULL` implícito (se ve en el `Row`). | `ls supabase/migrations/` → 2 archivos. `git diff supabase/migrations/20261008015400_estado_actual.sql` → vacío. `grep "profiles" lib/supabase/database.types.ts` → match. |
| CA-13 | Global (req. 1–16) | El build de producción compila sin errores. | `pnpm build` exit 0. |
| CA-14 | REQ-1, REQ-3, REQ-5 | End-to-end: con 2 usuarios logueados en 2 pestañas, `A` envía un mensaje, `B` lo ve en vivo sin recargar; `A` lo edita o borra, `B` ve la actualización en vivo sin recargar. | Flujo manual en `pnpm dev` (solo si `app/page.tsx` habilita el chat; si no, F3). En F1 se valida que **el hook** recibe los 3 eventos. |

---

## 6. Fuera de alcance / Preguntas abiertas

### Fuera de alcance (de F1, se cubren en fases siguientes)

- **F2:** migrar `components/messagesModule.tsx`, `components/testChannel.tsx`, `services/authClient.ts` y `app/login/page.tsx` a los dominios nuevos; *(los 4 errores de `tsc` por `supabaseClient` ya quedaron saldados en 2026-10-14 —ver P5—, así que F2 no debe replantearlos)*; eliminar las `interface Message` duplicadas; quitar `console.log`.
- **F3:** habilitar el chat en `app/page.tsx` y verificar realtime end-to-end con 2 sesiones del navegador.
- **F4:** specs formales para features nuevas (admin, hilos, edit, moderación, notificaciones).
- **F5:** tests. **F6+ (pendiente de naming):** paginación real, rate-limiting, búsqueda por texto.

### Preguntas abiertas (requieren decisión del usuario)

- **P1.** ¿El campo `email` es editable por el usuario? La spec lo deja fuera de `profileUpdateSchema` y de la UI (solo lo escribe el trigger vía `auth.users`). Si se quiere editar, se agrega una policy específica y una UI. *(Hoy no hay UI de edición, así que el default sigue siendo "no".)*
- **P2.** ¿**Quién** crea el bucket `profiles_avatars`? Opciones: (a) el usuario lo crea a mano con Supabase Studio, (b) un migration SQL, (c) un script de setup. La spec pre-ve **opción (b)** pero Supabase no expone `INSERT INTO storage.buckets` como migración estándar; se recomienda (a) + políticas aplicadas por `db-supabase` contra el stack local.
- **P3.** ¿El `deleteMessage` restringido al autor es el comportamiento deseado, o se quiere un rol moderador/admin? La spec asume **solo el autor** (REQ-4 / policy `messages_delete_own`). Si se quiere moderación, es una feature nueva F4.
- **P4.** ¿`messages_update_own` es un caso de uso de F1, o la policy debe eliminarse? La spec la incluye por paridad de RLS y porque el código actual ya no la usa; si se decide que F1 no edita mensajes, se elimina la policy y no se implementa el `updateMessage` en `actions.ts`. **Decisión pendiente.**
- **P5.** *(Resuelta, 2026-10-14.)* Los 4 errores de `tsc` por `supabaseClient` ya se resolvieron en `app/login/page.tsx`, `components/testChannel.tsx` y `services/authClient.ts` (`supabaseClient` → `createClient()` y `payload` tipado); no queda deuda pendiente sobre este punto.
- **P6.** ¿`app/profile/helps.ts` se mueve a `features/profiles/actions.ts` o se queda en `app/`? La spec propone moverla al dominio (regla: sin lógica de negocio en `app/`); el usuario debe confirmar.
- **P7.** ¿El límite `content` de `messages` es 4000 chars (spec) u otro valor? Decidido a 4000 para F1; se puede ajustar.

### Requiere aprobación del usuario

| Acción | Motivo |
| --- | --- |
| `pnpm add zod` | Nueva dependencia (AGENTS.md §2.3, regla dura 4). |
| `pnpm dlx supabase db reset` | Aplica la migración nueva (AGENTS.md §13, decisión 2026-10-09: `db-supabase` no aplica migraciones). |
| `pnpm run gen:types` | Regenera el único archivo de tipos del cliente Supabase (script de `package.json`, UTF-8). |
| Crear el bucket `profiles_avatars` (manually o por script) | No hay migración estándar para buckets; decisión P2. |

---

## 7. Notas de implementación

- El `implementer` **no ve skills** por diseño (AGENTS.md §13); las reglas de Zod/RLS/realtime viajan en el encargo que el orquestador le pasa.
- `zod` no está instalado. El implementer **no debe** escribir `import { z } from "zod"` hasta que el usuario apruebe `pnpm add zod`. Mientras tanto, los files `schemas.ts` se dejan con el comentario `// TODO(zod): aprobar pnpm add zod` y las funciones de validación como `throw new DomainError("zod pendiente de instalar")`. *(Decisión del orquestador si prefiere bloquear todo hasta aprobación.)*
- No se usa `apply_migration` del MCP (AGENTS.md §13): toda migración es un archivo.
- Todos los `throw` de strings en `services/**` se eliminan; los nuevos son `throw new DomainError(...)` o `throw new Error(...)` con mensaje corto.
