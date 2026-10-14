# F1 — Reconexión con Supabase: unificar dominio de usuario, RLS y realtime

> **Estado:** implementada e ítem a ítem (F1 y F2 cerradas, 2026-10-14, ver §6.1). El único ítem abierto es la deuda de CA-5/REQ-5: la verificación del payload `DELETE` completo (RIF FULL) **no se cumple en el stack local** (evidencia de 2026-10-14 en REQ-5/CA-5); la decisión de tolerar `old.id` en local está tomada, queda pendiente la verificación en cloud y el cierre de P8 (ver §6.1).
> **Fase:** F1 (reconexión + cimientos) implementada; F2 (migración de la UI legacy) cerrada 2026-10-14; pendiente F3 (runtime entre usuarios).
> **Requiere aprobación del usuario:** instalar `zod` (hecho); aplicar la migración con `pnpm dlx supabase db reset` (hecho); la verificación del payload `DELETE` completo en entorno cloud sigue pendiente (decisión sobre `old` truncado en local pendiente de P8; evidencias de runtime del 2026-10-14 en REQ-5/CA-5).

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
- **REQ-5.** `messages` tiene `REPLICA IDENTITY FULL` aplicada, de modo que **el contrato esperado** de los payloads de `DELETE`/`UPDATE` sea el registro completo (la documentación de Supabase promete que el realtime service emite `old_record`/`new_record` completos). **Verificable en el esquema:** `SELECT relreplident FROM pg_class WHERE oid = 'public.messages'::regclass;` → `f`. **Sonda de runtime contra el stack local (independiente, ejecutada 2026-10-14 tras reiniciar el stack, con `relreplident = 'f'` confirmado por SQL):** INSERT y UPDATE llegan con `new` completo ✅; el `old` de `DELETE` llega **solamente con `{id}`** ❌ (sin `content`, `user_id` ni `created_at`) — comportamiento que **no se cumple en local**, pese a RIF FULL (posible diferencia de versión del servicio realtime local). **Decisión implementada:** ante el payload truncado, y dado que `messagesModule.applyRealtimeEvent` solo consume `old.id` en DELETE, el hook `useMessagesRealtime` valida **solo `old.id`** en `DELETE` (INSERT/UPDATE siguen exigiendo `id` + `created_at`); la app no se ve afectada. **La aceptación plena de REQ-5 (payload `old` completo) queda pendiente de verificar en un entorno cloud** (ver §6.1, CA-5 y P8).
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

> `zod` aprobado e instalado (`pnpm add zod`). El bloque refleja el archivo implementado (los validadores se simplificaron a `z.string()`; `profileInsertSchema` de la propuesta original no se implementó — el trigger lo escribe, no el cliente).

```ts
// features/profiles/schemas.ts
import { z } from "zod";

// Perfil completo (row de `profiles`).
// `id` coincide con `auth.users.id` (1:1), por eso el RLS usa `id = auth.uid()`.
export const profileSchema = z.object({
  id: z.string(),
  created_at: z.string(),
  email: z.string().nullish(),
  username: z.string().nullish(),
  full_name: z.string().nullish(),
  avatar_url: z.string().nullish(),
});

// Input de actualización permitida al usuario (solo campos que el RLS permite modificar).
// `id` queda fuera: el RLS lo fija a `auth.uid()` vía `USING`/`WITH CHECK`.
// `email` queda fuera: no se edita en esta fase (ver P1).
export const profileUpdateSchema = z.object({
  username: z.string().nullish(),
  full_name: z.string().nullish(),
  avatar_url: z.string().nullish(),
});

// Autor de un mensaje: subconjunto del perfil expuesto al resto del chat.
// Se sirve únicamente a través de `index.ts` de este dominio (excepción `chat → profiles`).
export const messageAuthorSchema = z.object({
  id: z.string(),
  username: z.string().nullish(),
  avatar_url: z.string().nullish(),
});
```

### 3.2 Zod — `features/chat/schemas.ts`

> `zod` aprobado e instalado. `messageSchema` de la propuesta original exigía `content: z.string().min(1)`; lo que se implementó es `z.string().nullish()`, porque `DELETE`/optimistas pueden llegar con `content` nulo (ver REQ-5).

```ts
// features/chat/schemas.ts
import { z } from "zod";
import { messageAuthorSchema } from "@/features/profiles";

// Mensaje completo de la tabla `messages`.
export const messageSchema = z.object({
  id: z.string(),
  created_at: z.string(),
  content: z.string().nullish(),
  user_id: z.string().nullish(),
});

// Lo único que un cliente puede escribir: nunca id, created_at ni user_id.
export const messageInsertSchema = z.object({
  content: z.string().min(1).max(4000),
});

// Mensaje junto con el perfil del autor (o null si no hay autor visible).
export const messageWithAuthorSchema = z
  .object({
    author: messageAuthorSchema.nullish(),
  })
  .merge(messageSchema);
```

El payload realtime quedó como **tipo** (no como esquema Zod) en `features/chat/types.ts`, con el nombre `RealtimeEventPayload`:

```ts
// features/chat/types.ts — evento realtime de la tabla `messages`.
export type RealtimeEventPayload =
  | { eventType: "INSERT"; new: Message; old: null }
  | { eventType: "UPDATE"; new: Message; old: Message }
  | { eventType: "DELETE"; new: null; old: Message };
```

El contrato de `old` asume el registro completo (`REPLICA IDENTITY FULL`, REQ-5); en runtime local (evidencia 2026-10-14, ver CA-5) el `old` de `DELETE` llega truncado a `{id}` y el hook lo valida solo por `old.id` (ver REQ-5 / CA-5 / §6.1).

### 3.3 SQL — migración nueva

> Aplicada: `supabase/migrations/20261009235112_reconexion_profiles_messages.sql` (creada con `pnpm dlx supabase migration new`; aplicada por el usuario con `pnpm dlx supabase db reset`). El bloque de abajo es el contenido declarado de la propuesta; si el archivo final difiere en detalles, el archivo es la fuente de verdad.

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

-- 8) Bucket de avatares: el bucket ES RUNTIME y no se crea en la migración
--    (el usuario lo crea a mano en el stack local, ver P2/§6.1), pero las
--    POLICIES sí viajan en el archivo `20261009235112`: select público +
--    insert/delete solo del dueño vía `storage.foldername(name))[1] = auth.uid()::text`.
--    La migración aplicada incluye también `CREATE INDEX messages_user_id_idx`,
--    grants sobre `profiles` y el índice no estaban en esta propuesta original.
```

**Justificación de las decisiones SQL:**

- **`profiles.id = auth.uid()`** (1:1) en vez de una FK a `auth.users`: la convención estándar de Supabase; `handle_new_user` ya lo asume y las policies usan `auth.uid()` en vez de `auth.users.id`.
- **`messages_select_all`**: el chat no tiene el concepto de "conversación privada" ni "hilo"; es un solo canal público. Si más adelante se necesitan hilos por par, se agrega una tabla `conversations` (fuera de alcance).
- **`messages_update_own`**: hoy no hay UI de edición (`services/messages.ts` no exporta `updateMessage`). Se define la policy por paridad y para que el RLS esté completo si un futuro feature la incorpora; si se decide que la edición no es un caso de uso de F1, se elimina sin romper nada.
- **`messages_delete_own`**: el código actual (`deleteMessage`) es genérico; la spec **lo restringe al autor** porque con RLS no puede quedar "cualquiera borra cualquier mensaje" y porque es el comportamiento esperado de un chat. Si el producto quiere un modo moderador, es una feature nueva.
- **`ON CONFLICT ... DO UPDATE` en el trigger**: el trigger `handle_new_user` corrió contra la base anterior (la tabla `users` tiene filas). Al migrar, la tabla `profiles` ya tiene la fila; el trigger re-corriendo tras un `supabase auth` futuro inserta otra vez. El `ON CONFLICT` lo hace idempotente.

---

## 4. Archivos afectados (propuesta → ejecutado)

> **Estas tablas fueron la propuesta original de F1 y se ejecutaron (2026-10-14).** Las filas que F2 resolvió se marcan como ~~tachadas~~ con la nota "resuelto 2026-10-14"; las eliminaciones ya aplicadas se marcan igual. **Lo que existe hoy** en `features/**` y `components/**`: ver §5 (criterios de aceptación contra el código actual).

### Crear (ejecutado)

| Archivo | Intención (original) | Estado (2026-10-14) |
| --- | --- | --- |
| `supabase/migrations/20261009235112_reconexion_profiles_messages.sql` | Migración nueva (ver §3.3). | **Creado y aplicado.** Contiene RLS, RIF FULL, storage policies sobre el bucket `profiles_avatars`, índice `messages_user_id_idx` y grants (ver §6.1 "Decisión implementada"). |
| `features/profiles/schemas.ts` | Contratos Zod de perfil (ver §3.1). | **Creado.** |
| `features/profiles/types.ts` | Tipos derivados: sin interfaces a mano. | **Creado** (los types se re-exportan con `import type { z } …` + export de `z.infer`, forma equivalente). |
| `features/profiles/actions.ts` | `getProfile`, `listProfiles`, `updateProfile`, `logOut`. | **Creado**, y se sumó `isAuthenticated` en F1 (bloqueo runtime). |
| `features/profiles/index.ts` | API pública. | **Creado:** expone `getProfile`, `listProfiles`, `updateProfile`, `logOut`, `isAuthenticated`, `ProfilesError`, `messageAuthorSchema`, `type Profile`, `type ProfileUpdate`, `type MessageAuthor`. **No expone `getAuthor`** (la excepción `chat → profiles` se consume vía `listProfiles` + `messageAuthorSchema`). |
| `features/profiles/errors.ts` | Error tipado del dominio (REQ-12). | **Creado** (`ProfilesError extends Error`). |
| `features/profiles/hooks/useProfile.ts` | *(opcional, solo si F2 lo pide)* | **No creado.** En F1 no se usó. |
| `features/profiles/components/` | *(opcional, F2)* | **No creado.** El perfil se sigue sirviendo desde `app/profile/`. |
| `features/chat/schemas.ts` | Contratos Zod de chat (ver §3.2). | **Creado.** |
| `features/chat/types.ts` | Tipos derivados + `RealtimeEventPayload`. | **Creado** (ver §3.2, bloque añadido). |
| `features/chat/actions.ts` | `listMessages`, `getMessagesRange`, `createMessage` (corrección `author` → `user_id`), `deleteMessage`. | **Creado.** |
| `features/chat/errors.ts` | Error tipado del dominio (REQ-12). | **Creado** (`ChatError extends Error`). |
| `features/chat/index.ts` | API pública (ver §5, CA-10). | **Creado:** expone acciones, `ChatError`, tipos (`Message`, `MessageInsert`, `MessageWithAuthor`, `RealtimeEventPayload`), esquemas Zod y **`useMessagesRealtime`** (ver §3.2 para el tipo `RealtimeEventPayload`). |
| `features/chat/hooks/useMessagesRealtime.ts` | Hook que se suscribe a `postgres_changes` de `messages`. | **Creado.** Canal `"messages-realtime"`, suscripción `postgres_changes` sobre `public.messages`, validación por evento (**verificada contra el código, 2026-10-14**): INSERT y UPDATE exigen `id` + `created_at` en `new`; **DELETE solo `old.id`** (decisión del 2026-10-14 por el payload truncado, ver REQ-5 / CA-5). |
| `features/chat/hooks/useMessages.ts` (estado combinado, opcional) | *(opcional)* | **No creado.** La UI (`components/messagesModule.tsx`) hace la fusión idempotente por `id` directamente sobre la lista base. |
| `lib/errors.ts` *(o en cada dominio)* | Clase `DomainError extends Error` central. | **Decisión: por dominio** — se crearon `features/profiles/errors.ts` y `features/chat/errors.ts` en su lugar (la opción "en cada dominio" de esta misma fila). |

### Modificar (ejecutado)

| Archivo | Intención (original) | Estado (2026-10-14) |
| --- | --- | --- |
| `app/page.tsx` | Descomentar `MessagesModule` o sustituirlo por el componente nuevo. | **Restaurado** — renderiza `<MessagesModule userId={user?.id} />` (ver memoria F2 "Chat restaurado"). |
| `app/profile/page.tsx` | Cambiar imports de `services/profile.ts` a `features/profiles/index.ts`. | **Hecho** — importa `getProfile` directamente de `@/features/profiles`. |
| `app/profile/helps.ts` | Pasar a `features/profiles/actions.ts` o eliminar `throw "…"`. | **ELIMINADO 2026-10-14** (código muerto: `uploadFile`/`getPublicUrl` sin importadores; ver §6 "F2 cerrado" y `MEMORY.md` "Últimos cambios · F2"). |
| `components/messagesModule.tsx` | Consumir `features/chat/index.ts`; eliminar `interface Message` duplicada. | **Hecho** — importa `type { Message, RealtimeEventPayload }` y `useMessagesRealtime` de `@/features/chat`; fusiona eventos idempotentemente por `id` (INSERT/UPDATE → upsert, DELETE → filtro por `old.id`). Sin `interface Message` local ni `author`. |
| `components/modernListMessages.tsx` | *(no estaba en la propuesta)* | **Creado/reacondicionado en F2** — recibe `currentUserId` del server component y `onLoadMore`; resuelve avatar/nombre por el perfil del autor; botón "Cargar más" dentro de la card. |

### Eliminar (ejecutado 2026-10-14)

| Archivo | Motivo |
| --- | --- |
| `services/profile.ts` | Reemplazado por `features/profiles/actions.ts`. |
| `services/messages.ts` | Reemplazado por `features/chat/actions.ts`. |
| `features/users/` (carpeta completa: `actions.ts`, `types.ts`, `index.ts`) | Unificado en `features/profiles/`. |
| `components/testChannel.tsx` | Legacy sin importadores; suscribía realtime dentro de un componente (violación de la regla dura 3 — realtime solo vive en `features/<domain>/hooks/`). Resuelto por F2. |
| `components/listMessages.tsx` | Legacy sin importadores; superado por `modernListMessages.tsx`. Resuelto por F2. |
| `components/createMessage.client.tsx` | Legacy sin importadores; superado por `components/createMessage.server.tsx`. Resuelto por F2. |
| `app/profile/helps.ts` | Código muerto con `throw "Error al subir la imagen"` (regla dura 6). Resuelto por F2. |

**No se modifica (intencional):**

- `supabase/migrations/20261008015400_estado_actual.sql` — migración ya aplicada; **inmutable** (regla dura 5).
- `lib/supabase/database.types.ts` — **solo** se regenera con `pnpm run gen:types` **después** de aplicar la migración nueva (el script de `package.json` escribe UTF-8; el redirecionamiento `>` directo en PowerShell produce UTF-16 y rompe ESLint).
- `.opencode/agents/*.md`, `opencode.json` — fuera de esta feature.
- `lib/supabase/client.ts`, `services/authClient.ts`, `app/login/page.tsx` — la deuda de `tsc` por `supabaseClient` está **saldada** (2026-10-14): en esos archivos `supabaseClient` pasó a `createClient()` y `payload` quedó tipado. No queda pendiente. *(Ver P5. `components/testChannel.tsx` fue **eliminado** en F2 — ver tabla "Eliminar".)*

### Dependencias entre dominios

- `features/chat/schemas.ts` **importa** `messageAuthorSchema` de `features/profiles/index.ts` (excepción acordada `chat → profiles`, AGENTS.md §4); `features/chat/index.ts` re-exporta `messageAuthorSchema` para la UI. **No se implementa `getAuthor`** (la excepción `chat → profiles` se resuelve hoy vía `listProfiles` + `messageAuthorSchema` directo en `components/`).
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
| CA-5 | REQ-5 | **Esquema (verificable):** `messages` con `REPLICA IDENTITY FULL`; `SELECT relreplident FROM pg_class WHERE oid = 'public.messages'::regclass;` → `f`. **Contrato esperado:** payloads de `DELETE`/`UPDATE` con registro completo. **Evidencia de runtime (stack local, sonda realtime independiente en el navegador, 2026-10-14, tras reiniciar el stack):** INSERT ✅ `new` completo `{id, content, user_id, created_at}`; UPDATE ✅ `new` completo; DELETE ❌ `old` = **solo `{id}`** (sin `content`, `user_id` ni `created_at`) → **REQ-5 no se cumple en local**, pese a RIF (posible diferencia de versión del servicio realtime). **Decisión implementada:** el hook `useMessagesRealtime` valida **solo `old.id`** en `DELETE` (INSERT/UPDATE siguen exigiendo `id` + `created_at`); `messagesModule.applyRealtimeEvent` solo consume `old.id` en DELETE, así que la app no se ve afectada. | (1) `SELECT relreplident FROM pg_class WHERE oid = 'public.messages'::regclass;` → `f`. (2) Sonda de runtime: abrir 2 pestañas del chat en `pnpm dev`; `A` crea y edita un mensaje → `B` ve INSERT/UPDATE con `new` completo; `A` borra → `B` ve `DELETE` con `old.id` (resto de campos ausentes) — **falla verificable en local**, no un defecto de la app. (3) **Aceptación plena (payload `old` completo)**: pendiente de repetir en un entorno cloud; si allí también llega truncado, se registra como limitación del servicio realtime (fuera del alcance de esta spec). Ver §6.1, P8. |
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

- **F2:** *(Cerrada 2026-10-14, ver §6.1.)* Los puntos de esta lista — `interface Message` duplicada, `console.log`, `supabaseClient` en componentes, migrar `messagesModule`/`testChannel`/`login` — están **resueltos**. Los 3 componentes legacy (`testChannel.tsx`, `listMessages.tsx`, `createMessage.client.tsx`) y `app/profile/helps.ts` fueron eliminados; la deuda de `tsc` quedó saldada 2026-10-14 (ver P5).
- **F3:** verificación realtime entre usuarios distintos (CA-14) + creación del bucket `profiles_avatars` en Studio (CA-7) + cierre de P8 si `old` completo llega en cloud. UPDATE sin UI.
- **F4:** specs formales para features nuevas (admin, hilos, edit, moderación, notificaciones).
- **F5:** tests. **F6+ (pendiente de naming):** paginación real, rate-limiting, búsqueda por texto.

### 6.1 Estado de avance (cierre F1 + F2, 2026-10-14)

> Sincronizado contra el código del repositorio (2026-10-14). Ver `MEMORY.md` para el estado global y el smoke visual #2.

**Hecho:**

- F1 implementada: migración `20261009235112_reconexion_profiles_messages.sql` creada y aplicada (RLS, RIF FULL, trigger idempotente, storage policies, índice `messages_user_id_idx`, grants).
- `features/profiles/` y `features/chat/` creados con esquemas Zod, tipos derivados, `errors.ts` por dominio, `actions.ts`, `index.ts` y `useMessagesRealtime.ts`.
- `zod` instalado (`pnpm add zod`); `pnpm run gen:types` regeneró `lib/supabase/database.types.ts` sin diff vs. el stack local.
- Deuda F2 saldada 2026-10-14: `interface Message` duplicada, `throw "..."`, `console.log`, realtime fuera de hooks, `supabaseClient` en componentes — todas resueltas; ver tabla "Eliminar" (§4) para `testChannel.tsx`, `listMessages.tsx`, `createMessage.client.tsx` y `app/profile/helps.ts`.
- DoD en verde: `pnpm lint` 0 errores, `pnpm exec tsc --noEmit` 0, `pnpm build` 0.

**Abierto:**

- **Bucket `profiles_avatars` (CA-7):** aún no está creado en el stack local — el usuario lo crea en Studio (decisión P2); las policies de Storage sí están en la migración aplicada.
- **CA-14 / F3:** verificación end-to-end entre usuarios distintos. Smoke #2 cubrió una sola sesión real (INSERT/UPDATE/DELETE en vivo, borrado externo por SQL) pero **sin un segundo usuario en paralelo**; UPDATE no tiene UI hoy.
- **CA-5 (ver P8):** el `old` de `DELETE` llega truncado en el stack local; verificación con `old` completo pendiente de un entorno cloud.
- **Burbuja doble transitoria del envío optimista** (observada por el reviewer, no visible en el smoke #2): cosmética y de ventana mínima; se arregla solo si se vuelve molesta.

### Preguntas abiertas (requieren decisión del usuario)

- **P1.** ¿El campo `email` es editable por el usuario? La spec lo deja fuera de `profileUpdateSchema` y de la UI (solo lo escribe el trigger vía `auth.users`). Si se quiere editar, se agrega una policy específica y una UI. *(Hoy no hay UI de edición, así que el default sigue siendo "no".)*
- **P2.** ¿**Quién** crea el bucket `profiles_avatars`? Opciones: (a) el usuario lo crea a mano con Supabase Studio, (b) un migration SQL, (c) un script de setup. La spec pre-ve **opción (b)** pero Supabase no expone `INSERT INTO storage.buckets` como migración estándar; se recomienda (a) + políticas aplicadas por `db-supabase` contra el stack local.
- **P3.** ¿El `deleteMessage` restringido al autor es el comportamiento deseado, o se quiere un rol moderador/admin? La spec asume **solo el autor** (REQ-4 / policy `messages_delete_own`). Si se quiere moderación, es una feature nueva F4.
- **P4.** ¿`messages_update_own` es un caso de uso de F1, o la policy debe eliminarse? La spec la incluye por paridad de RLS y porque el código actual ya no la usa; si se decide que F1 no edita mensajes, se elimina la policy y no se implementa el `updateMessage` en `actions.ts`. **Decisión pendiente.**
- **P5.** *(Resuelta, 2026-10-14.)* Los 4 errores de `tsc` por `supabaseClient` ya se resolvieron en `app/login/page.tsx`, `components/testChannel.tsx` y `services/authClient.ts` (`supabaseClient` → `createClient()` y `payload` tipado); no queda deuda pendiente sobre este punto.
- **P6.** *(Resuelta 2026-10-14.)* `app/profile/helps.ts` se **eliminó** — era código muerto (`uploadFile`/`getPublicUrl` sin importadores); si en F3 se sube avatar, será una acción nueva de `features/profiles`.
- **P7.** ¿El límite `content` de `messages` es 4000 chars (spec) u otro valor? Decidido a 4000 para F1; se puede ajustar.
- **P8.** *(Abierta, 2026-10-14.)* CA-5/REQ-5: en el stack local `DELETE` llega con `old = { id }` solo, pese a `REPLICA IDENTITY FULL`. ¿Se acepta ese comportamiento como "contrato implementado" y se re-forza cuando el equipo se suba a cloud, o se busca un workaround (p. ej. `OLD` en el trigger, o `replica identity` a nivel función — no está soportado hoy por `supabase-js`)? El hook validó "solo `old.id`" como workaround local. **Decisión pendiente del usuario.**

### Requiere aprobación del usuario (estado 2026-10-14)

| Acción | Estado |
| --- | --- |
| `pnpm add zod` | **Aprobada e instalada.** |
| `pnpm dlx supabase db reset` | **Aprobada y aplicada.** (ver §6.1) |
| `pnpm run gen:types` | **Aprobada y ejecutada.** Sin diff vs. el stack local. |
| Crear el bucket `profiles_avatars` (manually o por script) | **Pendiente** — el usuario lo crea en Studio (decisión P2); las policies de Storage ya están en la migración aplicada. |
| Cierre de P8: decisión sobre payload `DELETE` truncado | **Pendiente** — see §6.1 / P8; si en cloud llega completo, se re-fuerza el hook y se documenta en `MEMORY.md`. |

---

## 7. Notas de implementación

- El `implementer` **no ve skills** por diseño (AGENTS.md §13); las reglas de Zod/RLS/realtime viajan en el encargo que el orquestador le pasa.
- `zod` **aprobado e instalado** (2026-10-14). Los archivos `schemas.ts` se escribieron con `z` directamente.
- No se usa `apply_migration` del MCP (AGENTS.md §13): toda migración es un archivo.
- Los `throw` de strings en `services/**` se eliminaron en F1; los nuevos son `throw new ProfilesError(...)` o `throw new ChatError(...)` con mensaje corto (ver §6.1).
