# F3 — Avatar de perfil: subir, reemplazar y eliminar

> **Estado:** aprobada y cerrada el 2026-10-14, implementada el mismo día, sin deudas abiertas (las dos deudas menores cerradas el 2026-10-14; reviewer: `⚠️ APROBADO CON OBSERVACIONES`, todas resueltas).
> **Fase:** F3 (runtime). Precede la UI de avatar sobre el dominio `features/profiles`.
> **Aprobación:** aprobada por el usuario el 2026-10-14 con los defaults de §6.2: estrategia `remove`+`upload` (P1, **sin migración**), límite 2 MB (P5), GIFs aceptados (P6), `deleteAvatar` no-op idempotente (P7), cards separadas (P8), normalización por MIME (P9), celda única (P3), URL pública (P4). Los pendientes de §6.3 quedaron **sin aprobarse por no ser necesarios**. La alternativa `upsert` de §6.3.1 quedó documentada pero **no se usó**. No se instalaron librerías.

---

## 1. Contexto

El chat y el perfil muestran el avatar del autor, pero hoy **no hay forma de subirlo**. El campo `profiles.avatar_url` existe (nullable) y los consumidores ya lo leen con fallback a iniciales (`components/modernListMessages.tsx`: `authorProfile?.avatar_url || selfProfile.avatar_url || https://ui-avatars.com/api/?name=…`), pero la columna siempre queda `NULL` porque el formulario de perfil (`app/profile/form.tsx`) solo edita `username`.

Los cimientos ya están puestos (F1/F2, ver `MEMORY.md`):

- **Bucket `profiles_avatars` ya existe** en el stack local (lectura pública, escritura solo del dueño). No es trabajo de esta feature (deuda F3 saldada).
- **Policies de Storage ya aplicadas** (§11 de la migración `20261009235112`): `profiles_avatars_select_public`, `profiles_avatars_insert_own`, `profiles_avatars_delete_own`, todas sobre `storage.objects` y ancladas al bucket `profiles_avatars`. **Convención de path fija:** los objetos van en `<auth.uid()>/<archivo>`, y el RLS comprueba `(storage.foldername(name))[1] = auth.uid()`.
- **DOMINIO `features/profiles/`** con `schemas.ts` (incluido `profileUpdateSchema` que ya acepta `avatar_url: z.string().nullish()`), `types.ts`, `errors.ts` (`ProfilesError`), `actions.ts` (`getProfile`, `listProfiles`, `updateProfile`, `logOut`, `isAuthenticated`) e `index.ts`.
- **Decisión de arquitectura ya tomada** (`MEMORY.md`, deuda F2): la subida de archivo NO vive en `app/` — es una acción del dominio `features/profiles`. `app/profile/helps.ts` (con `uploadFile`/`getPublicUrl`) fue eliminado en F2.

Este spec resuelve el único item de F3 pendiente relacionado con avatar: la subida como acción del dominio. No toca realtime (no aplica a Storage), no instala dependencias y no requiere migración (P1 = `remove`+`upload`; la alternativa `upsert` de §6.3.1 quedó documentada pero no se usó).

---

## 2. Requisitos

- **REQ-1.** El usuario logueado puede **subir** su avatar desde el formulario de perfil: elegir archivo (input `file`), ver **preview** antes de subir, y persistir la **URL pública** resultante en `profiles.avatar_url`. El consumidor (chat/perfil) no cambia su contrato: lee `avatar_url` igual que hoy.

- **REQ-2.** Cada avatar de un usuario vive en **una única celda del bucket**: `profiles_avatars/<auth.uid()>/avatar.<ext>`. La extensión refleja el MIME aceptado. La política `profiles_avatars_insert_own` (RLS) ya exige esa estructura de carpeta; la estrategia de nombre la fija esta spec sobre esa base.

- **REQ-3.** **Reemplazar** es idempotente por celda: subir de nuevo **sobrescribe** el objeto de la celda (mismo path) y actualiza `avatar_url`. No se acumulan objetos huérfanos por usuario y no se necesita un paso de "borrar el anterior" separado. Con las policies vigentes (sin `FOR UPDATE` en `storage.objects`), el "borrar el anterior" **es** parte del flujo de reemplazo: `remove` + `upload` (ver §3.3, P1 y CA-3).

- **REQ-4.** El usuario puede **eliminar** su avatar: se borra el objeto del bucket, `avatar_url` queda `NULL` y el chat vuelve al fallback de iniciales. Los consumidores no cambian su lógica (el `|| fallback` ya gestiona `NULL`).

- **REQ-5.** **Validación del archivo** (cliente + server action), sin librerías nuevas:
  - Tipo: solo `image/jpeg`, `image/png`, `image/webp`, `image/gif`.
  - Tamaño máx: **2 MB**.
  - Extensión derivada del MIME (`jpeg→jpg`, `png`, `webp`, `gif`).
  - Rechazo con un **mensaje claro al usuario** (vía `ProfilesError`) en caso de incumplir.

- **REQ-6.** La subida es una **server action del dominio** (`features/profiles/actions.ts`), expuesta vía `index.ts`. **Ninguna query Supabase vive en componentes** (regla dura 3); el form sigue siendo client y llama a la acción. La acción no vive en un archivo nuevo: se añade a `actions.ts` existente (ver §4).

- **REQ-7.** Toda lógica de subida pasa por `actions.ts` con **validación Zod** del contrato de dominio (`schemas.ts`) y errores tipados (`ProfilesError`). Queda prohibido `throw` de strings.

- **REQ-8.** **Sin cambios de DB**: no se crea ni altera ninguna tabla, no se crea el bucket y no se tocan las policies de Storage. Si durante la implementación se detectara la necesidad de una migración, se declara como **pregunta abierta** para que el orquestador la delegue a `db-supabase` (ver §6.2-P1 y §6.3.1).

- **REQ-9.** La UI de avatar vive en `features/profiles/components/` (regla dura 7) y se compone desde `app/profile/page.tsx` importando **solo** vía `@/features/profiles` (regla dura 4). El `app/profile/form.tsx` existente (editar `username`) no se modifica ni se elimina; la UI de avatar es un componente separado que compone la página.

- **REQ-10.** TypeScript estricto: sin `any`, sin `throw "…"` (regla dura 6). Los tipos de dominio se derivan con `z.infer` (regla dura 1). `lib/supabase/database.types.ts` no se modifica (no hay cambio de esquema).

---

## 3. Modelo de datos

### 3.1 Zod — `features/profiles/schemas.ts` (nuevo schema)

> El archivo `schemas.ts` ya existe. Se **añade** `avatarUploadedSchema` (contrato del *output* de la acción) más las constantes de validación `AVATAR_MIME_EXT` / `AVATAR_MAX_BYTES`. `profileUpdateSchema` **ya acepta** `avatar_url: z.string().nullish()`, así que persistir la URL reutiliza ese schema sin cambios.
> El *input* de la acción (el `File`) no es un schema Zod — ver la nota de contrato de §3.1 y el resumen de §3.4.

```ts
// features/profiles/schemas.ts — NUEVO (añadir al archivo existente)
import { z } from "zod";

// Contractos de dominio para la acción uploadAvatar:
//   - el cliente sube el archivo (File) y el server la valida.
//   - el server devuelve la URL pública persistida.
//
// `File` no es representable de forma portable en Zod (es un constructor
// del DOM, no un shape de datos serializable); la validación del File se
// hace en la action (tamaño/tipos) y el schema aquí modela el *output*
// de la acción que la UI consumirá.
export const avatarUploadedSchema = z.object({
  avatar_url: z.string().url().nullish(),
});

// Extensión permitida → MIME aceptado (para la validación en action.ts).
// Se declara aquí como constante para que la UI y la action la compartan.
export const AVATAR_MIME_EXT: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
  "image/gif": "gif",
};
export const AVATAR_MAX_BYTES = 2 * 1024 * 1024; // 2 MB
```

> **Nota de contrato.** El **input** de la acción no es un schema Zod: es `{ file: File }` (`File` no es un objeto JSON-serializable ni se presta a `z.infer`). Se valida manualmente contra `AVATAR_MIME_EXT` + `AVATAR_MAX_BYTES` en la action y el error se lanza como `ProfilesError`. El **output**, en cambio, sí es un esquema Zod (`avatarUploadedSchema`, arriba) para tipar lo que la UI recibe y persiste y para no reinventar el `avatar_url` ya presente en `profileUpdateSchema`.

### 3.2 SQL — estado actual (sin migración nueva)

> **No se crea ninguna migración en esta feature.** La estructura de tabla y policies ya existe. Se documenta el estado vigente para referencia del implementer.
> **Excepción:** si el usuario decide usar `upsert: true` (P1), se propone una migración pequeña en §6.3.1.

**Tabla `profiles`** (migración `20261009235112`):
- `avatar_url text NULL` — columna destino de la URL pública. **No cambia.**
- RLS `profiles_update_own` (USING + WITH CHECK `id = auth.uid()`) — **ya permite** `UPDATE ... SET avatar_url = ...` para el propio registro. **No cambia.**

**Bucket `profiles_avatars`** (runtime, ya existe en el stack local):
- `public: true` (lectura pública).
- Convención de path: `<auth.uid()>/<archivo>` (ver §3.3 y policies abajo).

**Policies de Storage** (migración `20261009235112` §11, ya aplicadas):
```sql
-- SELECT: lectura pública de cualquier objeto del bucket.
CREATE POLICY "profiles_avatars_select_public" ON storage.objects
  FOR SELECT TO authenticated, anon
  USING (bucket_id = 'profiles_avatars');

-- INSERT: solo el dueño puede subir en su propia carpeta.
CREATE POLICY "profiles_avatars_insert_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  );

-- DELETE: solo el dueño puede borrar de su propia carpeta.
CREATE POLICY "profiles_avatars_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  );
```

> **Nota crítica:** las policies vigentes cubren `SELECT`, `INSERT` y `DELETE`, pero **no** `UPDATE`. Supabase Storage implementa `upsert: true` como `SELECT → UPDATE` (si existe el path) o `INSERT` (si no existe). Con las policies actuales, `upsert` sobre una celda **ya escrita** **falla con RLS violation** porque UPDATE está vetado. Esto es el problema central de REQ-3 (ver §3.3 y P1).

**Sin `ALTER TABLE`, sin `INSERT INTO`, sin `CREATE INDEX`** sobre `profiles` (no cambia ninguna tabla). Las políticas de Storage se **completan** con una migración nueva opcional (ver §3.3 / §6.2-P1 / §6.3.1).

### 3.3 Estrategia de reemplazo (decisión a justificar)

La spec fija la celda como `profiles_avatars/${user.id}/avatar.<ext>` (path único por usuario, extensión fija según MIME).

**Justificación:**
1. **La policy RLS exige esa estructura** (`(storage.foldername(name))[1] = auth.uid()`), así que la primera segmentación del path es obligatoria: `<user.id>`.
2. **Celda única por usuario** ⇒ *reemplazar* = borrar el objeto de la celda (si su extensión cambió) + insertar el nuevo. No queda "historial" de avatares (fuera de alcance, ver P3).
3. **Extensión fija según MIME** (`jpg`, `png`, `webp`, `gif`) en vez de conservar la extensión original del cliente:
   - **Seguridad:** el nombre no depende del input del usuario (nunca una extensión arbitraria).
   - **Determinismo del reemplazo:** al subir una vez más, se sabe el *nuevo* path (`avatar.jpg` si jpeg) y el *antiguo* (`avatar.png` si se subió png antes).
4. **Se descarta `upsert: true`** de Supabase Storage como estrategia de reemplazo: `upsert` implementa `SELECT → UPDATE` sobre una celda existente, pero las policies vigentes no tienen `FOR UPDATE` (ver §3.2, nota crítica). `upsert` **solo** es viable en el primer upload (cuando la celda no existe aún, cae a INSERT y `profiles_avatars_insert_own` lo permite). En el segundo en adelante **falla** con RLS violation.
5. **Se descarta "timestamp + nombre original"** (`<uid>/avatar-2026-10-14-…jpg`): genera huérfanos (necesita cleanup de los antiguos), no es determinista al reemplazar y no lo pide ninguna policy.

**Estrategia recomendada:** celda fija `<uid>/avatar.<ext>` + **`remove` del antiguo si `avatar_url` no es NULL** + **`upload` del nuevo**. Si la extensión es la misma (por ejemplo png→png), `remove` + `upload` sobre el mismo path sigue siendo válido (DELETE + INSERT, ambas políticas existen).

**Resumen de flujos válidos con las policies vigentes:**
- **Primer upload** (avatar_url es NULL): `upload(<uid>/avatar.<ext>)` → INSERT OK (política `insert_own`).
- **Reemplazo mismo MIME** (png→png): `remove(<uid>/avatar.png)` → DELETE OK (política `delete_own`), luego `upload(<uid>/avatar.png)` → INSERT OK.
- **Reemplazo distinto MIME** (png→jpg): `remove(<uid>/avatar.png)` → DELETE OK, luego `upload(<uid>/avatar.jpg)` → INSERT OK.
- **Eliminar**: `remove(<uid>/avatar.<ext_actual>)` → DELETE OK, luego `updateProfile({ avatar_url: null })`.
- **`upsert`**: ❌ **No disponible** para reemplazo (falta policy UPDATE; ver §3.2 nota crítica y P1).

```
uploadAvatar(file):
  1. Validar (tipo + tamaño), lanzar ProfilesError si incumple.
  2. ext = AVATAR_MIME_EXT[file.type];  newPath = `${user.id}/avatar.${ext}`
  3. profile = getProfile();  oldUrl = profile.avatar_url
  4. Si oldUrl !== null:
       oldPath = extraer path del bucket (tras "profiles_avatars/").
       supabase.storage.from("profiles_avatars").remove([oldPath])
       (si oldPath === newPath, el borrado sigue siendo obligatorio:
        INSERT sobre un path ya existente falla; si oldPath !== newPath,
        el borrado evita el huérfano).
     Si oldUrl === null: primer upload, no hay nada que borrar.
  5. supabase.storage.from("profiles_avatars").upload(newPath, file, { cacheControl: '3600' })
     // INSERT, permitido por profiles_avatars_insert_own.
  6. publicURL = getPublicUrl(newPath)
  7. updateProfile({ avatar_url: publicURL })  // persistir.

deleteAvatar():
  1. profile = getProfile();  oldUrl = profile.avatar_url
  2. Si oldUrl === null: no-op idempotente, devuelve { avatar_url: null } (P7 resuelta).
  3. oldPath = extraer path del bucket (tras "profiles_avatars/").
  4. supabase.storage.from("profiles_avatars").remove([oldPath])
     (política delete_own).
  5. updateProfile({ avatar_url: null })  // NULL → el chat vuelve al fallback.
```

### 3.4 Schema Zod de la acción (resumen de contrato)

> Se incluye aquí para claridad; la fuente de verdad es `schemas.ts` (§3.1).

- **Input de `uploadAvatar`** (no Zod, validado en action): `{ file: File }` — verificación: `file.type ∈ AVATAR_MIME_EXT` y `file.size ≤ AVATAR_MAX_BYTES`.
- **Output de `uploadAvatar`**: `{ avatar_url: string | null }` (match `avatarUploadedSchema`).
- **Input de `deleteAvatar`**: `{}` (sin args).
- **Output de `deleteAvatar`**: `{ avatar_url: null }` (match `avatarUploadedSchema`).

---

## 4. Archivos afectados (propuesta)

> **Nota de arena (AGENTS.md §13):** el `implementer` solo escribe en `features/**`. El `app/profile/page.tsx` y, en su caso, `app/profile/form.tsx` los toca el **orquestador** (o un agente refactor) al componer la nueva UI. Esta spec enumera **todos** los archivos; el orquestador decide la partida de cada uno.

### Crear

| Archivo | Intención | Arena |
| --- | --- | --- |
| `features/profiles/components/AvatarUpload.tsx` | Componente client de la UI de avatar (input file + preview + botón subir/reemplazar + botón eliminar + estado de error/éxito). Importa **solo** de `@/features/profiles` (regla dura 4). No hace queries Supabase (regla dura 3). | implementer |

### Modificar

| Archivo | Intención | Arena |
| --- | --- | --- |
| `features/profiles/actions.ts` | Agregar `uploadAvatar(file)` y `deleteAvatar()`. Validación en la action (tipo + tamaño) + `remove([oldPath])` si `avatar_url` no es NULL + `upload(newPath, file)` + persistencia vía `updateProfile`. Errores tipados (`ProfilesError`). | implementer |
| `features/profiles/schemas.ts` | Añadir `avatarUploadedSchema` + `AVATAR_MIME_EXT` + `AVATAR_MAX_BYTES` (§3.1). No toca los schemas existentes. | implementer |
| `features/profiles/types.ts` | Derivar y exportar `type AvatarUploaded = z.infer<typeof avatarUploadedSchema>` (y la constante `AVATAR_MAX_BYTES` si se quiere tipar como `const`). | implementer |
| `features/profiles/index.ts` | Exponer `uploadAvatar`, `deleteAvatar`, `avatarUploadedSchema`, `type AvatarUploaded`, `AVATAR_MIME_EXT`, `AVATAR_MAX_BYTES`. (Los existentes se conservan.) | implementer |
| `app/profile/page.tsx` | Componer el nuevo `<AvatarUpload />` bajo el `<Form />` existente (o en un card/pane propio), importando `getProfile` (ya lo hace) y el componente. **No se modifica el `<Form />` de username.** | orquestador / refactor |
| `app/profile/form.tsx` | **No se modifica** (sigue editando solo `username`). La UI de avatar es un componente hermano, no un input más del form. | — |

### Eliminar

Ninguno. `app/profile/helps.ts` ya fue eliminado en F2 (ver `MEMORY.md`). No hay código muerto por avatares que quitar.

### No se modifica (intencional)

- `supabase/migrations/**` — inmutable (regla dura 5). **No se crea ninguna migración** (o una pequeña en §6.3.1 si se opta por `upsert`).
- `lib/supabase/database.types.ts` — sin cambio de esquema; no se regenera.
- `components/modernListMessages.tsx` — el consumidor de `avatar_url` NO cambia: su contrato (`authorProfile?.avatar_url || selfProfile.avatar_url || fallback`) sigue siendo válido ahora que `avatar_url` se llena.
- `features/chat/**` — no toca el dominio de chat.
- `.opencode/agents/*.md`, `opencode.json`, `package.json` — fuera de esta feature.
- **Sin `pnpm add`** — la validación tipo/tamaño es código propio, no librería nueva (REQ-5).

### Dependencias entre dominios

- Ninguna nueva. `features/profiles` sigue siendo independiente de `chat`. El consumidor `modernListMessages.tsx` (en `components/`) lee `avatar_url` de `Profile` / `Profile[]` que ya recibe como prop; no cambia nada del lado de `chat`.

---

## 5. Criterios de aceptación

> **Precondiciones para las CA manuales:** stack local corriendo (`pnpm dlx supabase start`), `pnpm dev`, bucket `profiles_avatars` presente (ya existe), policies aplicadas (ya están), usuario de prueba `tester@chatapp.local` / `Tester1234!`.

| ID | Ligado a | Qué debe pasar | Cómo se comprueba |
| --- | --- | --- | --- |
| CA-1 | REQ-1, REQ-5, REQ-7 | La acción `uploadAvatar` valida el `File` (MIME permitido + ≤ 2 MB) y lanza `ProfilesError` con mensaje claro si incumple. | Prueba manual con 3 archivos: (a) `test.png` (~100 KB) → exit; (b) `test.pdf` → error; (c) `test.png` de 5 MB → error. En (b)/(c) la UI muestra el mensaje y **no** sube nada al bucket. Verificar en consola del server: `ProfilesError` con el mensaje esperado. |
| CA-2 | REQ-1, REQ-3 | Tras subir un avatar, `profiles.avatar_url` contiene la **URL pública** del objeto (`…/storage/v1/object/public/profiles_avatars/<uid>/avatar.<ext>`) y el chat muestra dicho avatar (no el fallback de iniciales). | `SELECT avatar_url FROM profiles WHERE id = <uid>;` → no NULL, path esperado. En el chat: el avatar del autor aparece (no es `ui-avatars.com`). |
| CA-3 | REQ-2, REQ-3 | Reemplazar un avatar (mismo tipo o distinto) deja **una sola celda** `<uid>/avatar.<ext_nuevo>` en Storage y `avatar_url` apunta al último objeto. Si el tipo cambia, el objeto del tipo anterior **fue borrado** antes de subir el nuevo (sin huérfanos del uid). | (1) `pnpm dlx supabase storage objects list --bucket profiles_avatars` → para `<uid>` consta **el último** `avatar.<ext_nuevo>` solo (si se subió `png` y luego `jpg`, el `png` no queda). (2) `SELECT avatar_url FROM profiles WHERE id = <uid>;` → apunta al último. (3) UI de perfil: el avatar mostrado es el último subido. |
| CA-4 | REQ-4 | Eliminar el avatar borra el objeto del bucket, pone `avatar_url = NULL` y el chat vuelve al fallback de iniciales. | `SELECT avatar_url FROM profiles WHERE id = <uid>;` → `NULL`. `pnpm dlx supabase storage objects list --bucket profiles_avatars` → no hay objeto `<uid>/avatar.*`. En el chat: el avatar del autor es el de `ui-avatars.com/api/?name=…`. |
| CA-5 | REQ-6 | Toda la lógica de subida vive en `features/profiles/**` (acciones + schemas). Ningún componente de UI (`app/**`, `components/**`, `features/*/components/**`) hace queries Supabase. | `pnpm exec tsc --noEmit` exit 0. `Select-String -Path "app/**","components/**","features/*/components/**" -Pattern 'supabase\.storage|\.from\("profiles"\)|\.from\("profiles_avatars"\)'` → **0 matches**. (Las acciones en `features/profiles/actions.ts` sí llaman a `supabase.storage` y `.from("profiles")`; **esas** sí son legítimas y están fuera del search path de esta CA.) |
| CA-6 | REQ-9 | La UI de avatar vive en `features/profiles/components/` y la página la compone. `app/profile/form.tsx` **no** está modificado (sigue editando solo `username`). | `git diff app/profile/form.tsx` → vacío. `ls features/profiles/components/` → presenta `AvatarUpload.tsx`. `app/profile/page.tsx` importa `<AvatarUpload />` de `@/features/profiles`. |
| CA-7 | REQ-7, REQ-10 | Sin `throw "texto"` y sin `any` nuevos en `features/profiles/**`. Los tipos de la acción son `z.infer` (`AvatarUploaded`). | `pnpm exec tsc --noEmit` exit 0. `Select-String -Path "features/profiles/**" -Pattern 'throw\s*"' \| any\b'` → 0 matches. `pnpm lint` exit 0. |
| CA-8 | REQ-8 | No se crea ninguna migración nueva en `supabase/migrations/` para esta feature y `database.types.ts` no se modifica. | `ls supabase/migrations/` → **el mismo set de antes** (solo `20261008015400_…` y `20261009235112_…`). `git diff lib/supabase/database.types.ts` → vacío. |
| CA-9 | Global (DoD, AGENTS.md §8) | `pnpm lint`, `pnpm exec tsc --noEmit` y `pnpm build` salen en verde. | `pnpm lint` exit 0. `pnpm exec tsc --noEmit` exit 0. `pnpm build` exit 0. |

---

## 6. Fuera de alcance / Preguntas resueltas

### 6.1 Fuera de alcance (no en esta feature)

- **Historial de avatares.** La celda `<uid>/avatar.<ext>` no conserva los anteriores (la subida nueva reemplaza el anterior; ver REQ-3 y §3.3). Si se quisiera, es una feature nueva (tabla `profile_avatars` + UI de selector).
- **Recorte/redimensión del avatar (carrucel/cropping en cliente).** El cliente sube la imagen tal cual. La optimización (reducir a 512×512, etc.) es una feature posterior (y requeriría `sharp` o equivalente, fuera de alcance por la restricción "sin instalar dependencias").
- **Avatar en otros puntos de la UI** (por ejemplo, si se agrega un header de chat que muestre el avatar propio como "Tú"). La spec solo garantiza que `profiles.avatar_url` se llena; los consumidores que ya la leen (`modernListMessages.tsx`) la verán sin cambios. Cualquier otro consumidor se adapta.
- **Avatar por rol/moderador** o avatares personalizados para el canal. No aplica (chat de un solo canal).
- **Realtime de avatar** (que el chat muestre el avatar nuevo en vivo sin recargar). `profiles` no está en `supabase_realtime` y no se espera cambiar esa decisión por esta feature (ver P2).

### 6.2 Preguntas resueltas (decisión del usuario, 2026-10-14)

- **P1.** *Resuelta:* `remove`+`upload` (borrar el antiguo, subir el nuevo — §3.3, **sin migración**). Se descarta `upsert: true` y la migración de §6.3.1 (queda documentada, no usada).
- **P2.** *Fuera de alcance (pendiente futura F3b si se pide).* `profiles` no entra en `supabase_realtime`; si el usuario lo pide, es una sub-spec o feature F3b con sus reglas de RLS/RFS (regla dura 8) y un `useProfileRealtime` propio.
- **P3.** *Resuelta:* celda única por usuario (REQ-2, REQ-3). Sin historial.
- **P4.** *Resuelta:* URL pública absoluta (`getPublicUrl`); el bucket y la lectura ya son públicos (`profiles_avatars_select_public`).
- **P5.** *Resuelta:* límite 2 MB (REQ-5, `AVATAR_MAX_BYTES`).
- **P6.** *Resuelta:* GIFs animados (`image/gif`) **aceptados** (REQ-5; `AVATAR_MIME_EXT` lo incluye).
- **P7.** *Resuelta:* `deleteAvatar` con `avatar_url = NULL` es **no-op idempotente** (devuelve `{ avatar_url: null }`).
- **P8.** *Resuelta:* **dos cards separadas** (username / avatar); la UI de avatar es un componente hermano, no un input más del form.
- **P9.** *Resuelta:* **normalizar según MIME** (`jpg`, `png`, `webp`, `gif`); se descarta preservar la extensión original del cliente.

### 6.3 Aprobaciones (resultado post-aprobación, 2026-10-14)

> P1 se resolvió por `remove`+`upload`, por lo que la migración de §6.3.1 **no se aplica** y ninguna acción de esta tabla resultó necesaria.

| Acción | Estado |
| --- | --- |
| `pnpm add` (librerías nuevas) | **No se propone ni se instala.** Validación código propio (REQ-5). |
| `pnpm dlx supabase db reset` | **No se aplica** (REQ-8). P1 = `remove`+`upload`: no hay migración. |
| `pnpm run gen:types` | **No se propone ni se ejecuta.** No cambia esquema. |
| Crear el bucket `profiles_avatars` | **No aplica.** Ya existe (deuda F3 saldada en `MEMORY.md`). |
| Ajustar policies de Storage | **No se aplica.** La alternativa `upsert` de §6.3.1 quedó documentada pero no usada. |

#### 6.3.1 Alternativa documentada, no usada (política UPDATE pendiente)

> **Estado (2026-10-14):** P1 se resolvió por `remove`+`upload`, por lo que esta migración **no se aplica ni se propone**. Se conserva el bloque como **documento de respaldo** caso de que en el futuro se opte por `upsert: true`.

Las policies existentes **no incluyen UPDATE** sobre `storage.objects` para el bucket `profiles_avatars`. Si en el futuro se prefiere `upsert: true` como estrategia de reemplazo (ver §3.3 / P1), falta esta migración. La spec **no la aplica por defecto** pero la documenta por si se decide:

```sql
-- Crear política UPDATE sobre storage.objects para el bucket profiles_avatars.
-- Solo el dueño puede sobrescribir objetos en su propia carpeta. Supabase CLI:
--   pnpm dlx supabase storage policies create
--     "profiles_avatars_update_own"
--     --table storage.objects
--     --command UPDATE
--     --role authenticated
--     --statement "bucket_id = 'profiles_avatars' AND (storage.foldername(name))[1] = (select auth.uid())::text"
--     --check "bucket_id = 'profiles_avatars' AND (storage.foldername(name))[1] = (select auth.uid())::text"
CREATE POLICY "profiles_avatars_update_own" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  )
  WITH CHECK (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  );
```

**Impacto:** requiere `pnpm dlx supabase db reset` (migración nueva) y es **única** (no afecta otras políticas). Requiere aprobación del usuario.

---

## 7. Notas de implementación para el orquestador

- **Arena.** `implementer` hace lo de `features/profiles/**` (schemas, tipos, acciones, componente de avatar). El `refactor` (o el orquestador) compone `app/profile/page.tsx`. **No se modifica `app/profile/form.tsx`**.
- **Modelo local del implementer.** El `implementer` usa `ollama/qwen3.8:latest#sin-pensar` (ver `MEMORY.md`, decisión 2026-10-14) con `steps: 20`. La UI de avatar es un componente de tamaño medio; si el implementer queda corto, el orquestador lo re-dispara con un encargo más acotado.
- **Encargo único = un trabajo.** Si el orquestador va a dividir (schemas → acciones → componente), cada encargo se despacha de a uno (AGENTS.md §13 "Encargos y veredictos").
- **Verificación.** El `implementer` cierra con `✅ HECHO` + salida literal de `tsc`/`lint`. El orquestador verifica con `reviewer` o con una lectura puntual del diff.
- **Smoke manual.** Tras implementar, hacer CA-1…CA-4 contra `tester@chatapp.local` y verificar en `pnpm dev` con el bucket real.
- **Smoke de reemplazo (CA-3).** Subir un avatar png, luego reemplazarlo por un jpg. Verificar que el objeto `png` **no** queda en el bucket (si queda, la policy `profiles_avatars_delete_own` no cubre DELETE sobre un path ya insertado — ver §3.3 y P1).

---

### Estado de implementación (2026-10-14, cerrado)

Aprobada el 2026-10-14 e implementada el mismo día. `uploadAvatar`/`deleteAvatar` y `AvatarUpload` salen por `index.ts` (ya previsto en §4); `app/profile/page.tsx` compone todo vía `@/features/profiles` (conforme a REQ-9). **Sin deudas abiertas**: las dos deudas menores que listaba esta sección original quedaron **resueltas el 2026-10-14** (ver abajo). DoD en verde: `pnpm lint` 0 errores, `pnpm exec tsc --noEmit` 0, `pnpm build` 0. Smoke completo CA-1…CA-4 en dev **y** en prod (`pnpm start`, puerto 3100).

**Deuda menor 1 (RESUELTA 2026-10-14) — "mensajes de `ProfilesError` enmascarados en prod".** Originalmente, `uploadAvatar`/`deleteAvatar` lanzaban `ProfilesError` (tipado) dentro de la server action, y en producción un genérico de Next.js se llevaba el mensaje (CA-1 solo era verificable en dev). El contrato de la acción cambió: ya **no lanzan**; devuelven `AvatarResult`, una **unión discriminada Zod por `ok`**:

- éxito: `{ ok: true, avatar_url: string }`
- error: `{ ok: false, code, message }`, con `code ∈ AVATAR_ERROR_CODES = INVALID_TYPE | TOO_LARGE | NOT_AUTHENTICATED | STORAGE_ERROR | PROFILE_ERROR`

El `try` cubre hasta `createClient()` y `getUser()` (un fallo de autenticación cae en `NOT_AUTHENTICATED`). **Verificado en prod** (`pnpm start`, puerto 3100): se dropó la policy INSERT de Storage temporalmente para forzar el fallo, y el mensaje "Error al subir el avatar: new row violates row-level security policy" se mostró **completo** en la UI; policy restaurada, regresión OK.

**Deuda menor 2 (RESUELTA 2026-10-14) — "ciclo de import `index → componente → index`".** El componente `AvatarUpload` ahora importa por **rutas relativas** (`../schemas`, `../actions`), rompiendo el ciclo; `index.ts` sigue exponiendo el componente para consumo desde `app/` (REQ-9 intacto).

**Hallazgo de runtime resuelto (2026-10-14): `bodySizeLimit` de Next.** Durante las pruebas de prod se encontró un **bug de infraestructura de Next**: el `bodySizeLimit` por defecto para server actions es **1 MB**, por debajo de `AVATAR_MAX_BYTES` (`2 * 1024 * 1024`). Todo avatar válido de 1–2 MB fallaba con "Body exceeded 1 MB limit" **antes** de llegar a la validación de la acción. **Resolución:** `experimental.serverActions.bodySizeLimit: "3mb"` en `next.config.ts` (margen de holgura sobre `AVATAR_MAX_BYTES`; cualquier payload > 2 MB lo rechaza `REQ-5` igualmente). **Verificado en dev y prod:** PNG de 1,68 MB sube correctamente; un PDF y un archivo de 21 MB son rechazados con su mensaje (`INVALID_TYPE` / `TOO_LARGE`), visible completo en la UI.

**Veredicto final del reviewer (2026-10-14):** `⚠️ APROBADO CON OBSERVACIONES` — sin reglas duras rotas (AGENTS.md §5), sin `any`, sin `throw` de strings, RLS/policies intactos; **todas las observaciones resueltas** (incluidas las dos deudas menores de arriba). Smoke completo CA-1…CA-4 en dev **y** en prod (`pnpm start`, puerto 3100); DoD en verde para esta sección (lint / tsc / build).
