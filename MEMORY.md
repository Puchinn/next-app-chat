# MEMORY.md

> **Diario del proyecto.** Se lee al iniciar cada tarea y se actualiza al cerrar cada sesión con cambios relevantes.
> Reglas y convenciones → ver `AGENTS.md`.
> Mantener corto: en "Últimos cambios" solo las últimas 3 a 5 entradas; lo anterior se rota a `docs/archive/`.

---

## Estado actual

**Fecha de actualización:** 2026-10-14
**Fase:** F1 y **F2 completadas** (UI legacy migrada a los dominios + realtime enchufado al hook). Config multiagente (F0.5) completada. Próxima: F3.

- ✅ **Definición de hecho en verde** (re-verificado 2026-10-14 tras F2): `pnpm lint` 0 errores (2 warnings preexistentes, bajaron de 4), `pnpm exec tsc --noEmit` exit 0, `pnpm build` exit 0.
- ✅ **F2 cerrada:** sin `interface Message` a mano, realtime vía `useMessagesRealtime` (regla dura 3), sin `throw "..."`, `console.log` fuera, a11y del login/perfil corregida, botón "Cargar más" dentro de la card y legacy huérfano eliminado (`testChannel`, `listMessages`, `createMessage.client`, `app/profile/helps.ts`).
- ✅ **Smoke visual #2 en navegador (2026-10-14):** login end-to-end; envío de mensaje → **botón de borrar presente sin recargar**; borrado en vivo (propaga UI + DB) y borrado externo por SQL (propaga a la UI); INSERT y UPDATE realtime sin recargar; avatares con nombre correcto (sin `null`/`undefined`/`src=""`); consola limpia (solo HMR); a11y verificada en DOM (`autocomplete` login, `label` asociada en perfil). **Usuario de prueba: `tester@chatapp.local` / `Tester1234!` (credencial local de dev, dada por el usuario; se puede borrar).**
- ✅ **Rama `chore/agent-rework`** con 4 commits: WIP snapshot (`cb5d61c`), fix de bloqueos (`0042aba`), config de agentes (`c2af16c`) y rewire (`a12b9e4`). **Sin merge a `main`.**
- ✅ **Config multiagente: 6 agentes** (`orchestrator`, `spec-writer`, `db-supabase`, `implementer`, `refactor`, `reviewer`), arenas y modelos sincronizados con `AGENTS.md` §13.
- ✅ **`services/` y `features/users/` eliminados.** Los 11 consumidores rewireados a `@/features/profiles` y `@/features/chat` (solo vía `index.ts`). `features/users/actions.ts` consultaba la tabla `users`, inexistente desde la migración: las páginas de perfil estaban rotas en runtime y ahora usan `profiles`.
- ✅ **Chat restaurado** en `app/page.tsx` (`MessagesModule` vuelve a renderizar).
- ✅ **Smoke visual #1 en navegador (2026-10-14, `chrome-devtools`):** login end-to-end, trigger `handle_new_user` crea perfil, envío de mensajes persiste en DB, realtime propaga INSERT y DELETE entre pestañas sin recargar, borrado propio funciona, update de perfil end-to-end, logout con redirect.
- ✅ **`pnpm run gen:types`** regenera `database.types.ts` en UTF-8 (el `>` de PowerShell escribía UTF-16 y ESLint lo leía como binario). Re-ejecutado 2026-10-14 tras el smoke de `db-supabase`: **sin diff** (DB local ↔ repo sincronizados).
- ✅ **Spec 01 sincronizada** con el código (nombre del hook, CA-9, comando de tipos, deuda de `tsc` saldada).
- ⏳ **Runtime sin verificar:** el bucket `profiles_avatars` (se crea en Studio, F3) y el UPDATE de mensaje (no tiene UI).
- ✅ **Deuda F2 y del smoke #1 saldadas (2026-10-14):** interfaces `Message` a mano, `throw "..."` en `helps.ts`, suscripción realtime dentro de `testChannel.tsx`, botón de borrar en mensajes en vivo, avatares rotos (`null`/`undefined`/`src=""`), `console.log` suelto, a11y de login/perfil y botón "Cargar más" fuera de la card.
- ⚠️ **Deuda nueva (F2 / smoke #2):**
  1. **CA-5 de spec 01 incumple en el stack local** — verificado 2026-10-14 con **sonda realtime independiente en el navegador** tras **reiniciar el stack** (`supabase stop` → `start` desde backup) y con `relreplident='f'` confirmado por SQL: INSERT ✅ `new` completo, UPDATE ✅ `new` completo, **DELETE ❌ `old` = solo `{id}`** (sin `created_at`). El reinicio **no lo arregló** (no es caché de esquemas). El hook tolera solo `old.id` (decisión adoptada); la app no se ve afectada. **Spec 01 sincronizada** (REQ-5, CA-5, §6.1) y **P8 abierta**: decidir si se acepta local o se re-fuerza al subir a cloud.
  2. **Burbuja doble transitoria en el envío optimista** (observación del `reviewer`, no llegué a verla en el smoke): mientras el `transition` está pendiente y llega el INSERT realtime, pueden coexistir el optimista (id `optimistic-…`) y el real. Cosmético y de ventana mínima; arreglar solo si se vuelve molesto.

---

## Decisiones

| Fecha      | Decisión                                                                                                                                                                                                                                                                         |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-10-07 | Documentación del proyecto en **español**. Código, identificadores, commits y ramas en **inglés** (Conventional Commits).                                                                                                                                                          |
| 2026-10-07 | Las specs SDD viven en **`docs/specs/`**, numeradas (`NN-nombre-feature.md`). Flujo: plan resumido + aprobación antes de escribir código o instalar librerías. Siempre `pnpm`.                                                                                                     |
| 2026-10-09 | Zod = contrato de dominio; `database.types.ts` generado = único tipado permitido del cliente Supabase. Excepciones de arquitectura: realtime en `features/<domain>/hooks/`; `chat → profiles` solo vía `index.ts`.                                                                  |
| 2026-10-09 | Permisos por agente en el frontmatter: **la última regla que coincide gana**; el `deny` catch-all vence a los defaults. `apply_migration` denegado por permiso; `db-supabase` no aplica migraciones (el usuario corre `supabase db reset`). CLI de Supabase solo con `pnpm dlx`.   |
| 2026-10-09 | `default_agent: orchestrator`; solo `implementer` con modelo y `steps` fijos por diseño. `chrome-devtools` reservado a un agente de tests futuro.                                                                                                                                 |
| 2026-10-14 | **`implementer` se mantiene estrecho: solo escribe código en `features/`.** El código fuera de `features/` (`app/`, `lib/`, `context/`, `components/`, `services/`) lo escribe el nuevo agente **`refactor` (remoto)**. **Revierte** la decisión del 2026-10-09 de ampliar la arena del `implementer`. |
| 2026-10-14 | **`orchestrator` gana arena de sincronización**: puede editar `AGENTS.md` y `.opencode/agents/**` (nadie podía tocarlos: por eso las decisiones quedaban solo en `MEMORY.md`). `opencode.json` y `package.json` los edita el usuario.                                                     |
| 2026-10-14 | **Tipos de Supabase: `pnpm run gen:types`** (script que redirige en cmd/UTF-8). prohibido el `>` de PowerShell a mano (escribe UTF-16). La allowlist literal de `db-supabase` se actualizó al script.                                                                                |
| 2026-10-14 | **`spec-writer` fija modelo local** (`ollama/qwen3.8:latest#sin-pensar`): heredar el global o usar un modelo free explícito falla 3/3 con `OpenCode's free tier can only be used from within OpenCode`. Causa raíz sin diagnosticar (deuda).                                          |
| 2026-10-14 | **`chrome-devtools` retirado de `opencode.json`** hasta F5 (no hay tests ni agente que lo use). Se re-añade con el agente de tests.                                                                                                                                                |
| 2026-10-14 | **Umbral trivial (AGENTS.md §2.8):** fix ≤3 líneas o de un solo archivo → sin spec ni reviewer. Spec obligatoria solo para features nuevas y cambios de DB.                                                                                                                        |
| 2026-10-14 | **`webfetch` añadido a `spec-writer` y `reviewer`** (la skill `supabase` les manda fetchear el changelog). `implementer` y `refactor` sin skills, por diseño.                                                                                                                      |
| 2026-10-14 | **`chrome-devtools` reactivado solo para `orchestrator`** (smoke/verificación visual: UI, consola, red). Acceso provisional hasta el agente de tests de F5. Decisión del usuario junto con descartar `@playwright/mcp` por ahora.                                                  |
| 2026-10-14 | **`ProfilesError` vive en `features/<dominio>/errors.ts`**, nunca exportada desde un archivo `"use server"` (Turbopack descarta el módulo entero; el fallo estaba oculto por la caché del build).                                                                                   |
| 2026-10-14 | **Validación del payload `DELETE` en `useMessagesRealtime`: solo exige `old.id`** (INSERT/UPDATE siguen exigiendo `created_at`). Motivo: en el stack local el `old` llega truncado pese a `relreplident='f'` (CA-5 de spec 01 incumplida en runtime). |
| 2026-10-14 | **`implementer` y `refactor` no pueden ejecutar `pnpm build` ni borrar archivos** (shell limitado a `tsc`/`eslint`): el build y los borrados los hace el orquestador. Sus encargos se cierran con `✅ HECHO` + verificación independiente del orquestador. |

---

## Deuda y bugs (inventario)

Cada ítem lleva la fase en la que se resuelve.

- [x] **[F1] `tsc`/`build`/lint rotos** — resueltos 2026-10-14: `supabaseClient` → `createClient()`, `database.types.ts` en UTF-8 vía `pnpm run gen:types`, y `ProfilesError` movida a `features/profiles/errors.ts` (causa real de los 21 errores de build).
- [x] **[F1] Rewirear consumidores de `services/` y `features/users/`** — hecho (11 archivos); `services/` y `features/users/` eliminados.
- [x] **[F0.5] Arena de `app/`, `lib/` y `context/`** — resuelto con el agente `refactor` (remoto), no ampliando al `implementer`.
- [~] **[F0.5] Smoke test de los 6 agentes** — parcial: `refactor` (5 encargos ✓), `implementer` (3 ✓), `spec-writer` (1 ✓ con modelo local), `reviewer` (3 ✓). `db-supabase`: **parcial** (2026-10-14, MCP en vivo contra el stack local: `list_migrations` + consultas de inspección + `pnpm run gen:types` sin diff). **Sigue faltando** un encargo real de migración (`supabase migration new` + `db reset`) cuando haya cambio de DB.
- [ ] **[F0.5] Causa raíz del fallo de modelo de `spec-writer`** — sigue sin diagnosticarse; workaround fijado en el frontmatter.
- [x] **[F2] `interface Message` a mano** en `messagesModule`, `modernListMessages`, `testChannel` y `listMessages` — resuelto 2026-10-14: reescritura de la UI por `refactor` sobre `type Message`/`MessageWithAuthor` de `@/features/chat` (`user_id` + perfil del autor); los 3 componentes legacy con `author` fueron eliminados.
- [x] **[F2] `throw "Error al subir la imagen"`** en `app/profile/helps.ts:21` — resuelto 2026-10-14 eliminando el archivo (código muerto: nadie importaba `uploadFile`/`getPublicUrl`). Si en F3 se sube avatar, va como acción de `features/profiles`.
- [x] **[F2] Realtime enchufado a hooks** — resuelto 2026-10-14: `testChannel.tsx` eliminado, `useMessagesRealtime` exportado desde `features/chat/index.ts` y consumido en `messagesModule` (fusión idempotente por `id`).
- [ ] **[F3] Verificar chat end-to-end con 2 sesiones distintas** — el smoke #2 cubrió una sesión (INSERT/UPDATE/DELETE en vivo, borrado externo) pero sin un segundo usuario en paralelo; UPDATE no tiene UI. Sin tests automatizados.
- [ ] **[F3] Bucket `profiles_avatars`** — el usuario lo crea en Studio (policies de Storage ya escritas en la migración).
- [ ] **[F3] CA-5 / P8 — payload de `DELETE` truncado en el stack local** (`old = {id}` pese a `relreplident='f'`) — **reinicio del stack hecho 2026-10-14: no lo arregló** (sonda realtime en navegador: INSERT/UPDATE completos, DELETE solo `id`). Spec 01 actualizada. **Queda la decisión P8**: aceptar el comportamiento local y re-validar en cloud (si allí llega completo, re-forzar la validación del hook).
- [ ] **[F5] Testing** (librería a consultar en su momento) y re-añadir `chrome-devtools`.

---

## Últimos cambios

- **2026-10-14 · CA-5** — Stack local **reiniciado** (`pnpm dlx supabase stop` → `start` desde backup; datos conservados) y regresión post-reinicio en verde (envío con botón de borrar + borrado en vivo + consola limpia). **Sonda realtime independiente en el navegador** (suscripción `postgres_changes` con `supabase-js`): `DELETE` sigue entregando `old = {id}` → el reinicio **no** arregla CA-5. `spec-writer` sincronizó `docs/specs/01-reconexion-supabase.md` (REQ-5, CA-5, tablas de archivos, nueva §6.1 y P8 abierta). Commits: `bfe8876` (F2) y `671b867` (docs).
- **2026-10-14 · F2** — **F2 cerrada y verificada en navegador.** `implementer` exportó `useMessagesRealtime` desde `features/chat/index.ts`; `refactor` reescribió `messagesModule` y `modernListMessages` (tipo del dominio en vez de `interface Message`, fusión idempotente de eventos realtime por `id`, `isMe` por prop → botón de borrar en mensajes en vivo, avatar/alt por perfil del autor, botón "Cargar más" dentro de la card) y limpió `app/` + `context/` (a11y de login y perfil, `console.log` del provider); el orquestador borró `testChannel.tsx`, `listMessages.tsx`, `createMessage.client.tsx` y `app/profile/helps.ts` (código muerto con el `throw "..."`). `reviewer: ⚠️ APROBADO CON OBSERVACIONES`. El **smoke #2** destapó que el borrado en vivo no se aplicaba en la UI → causa raíz: el hook exigía `created_at` en `old` del `DELETE` y ese payload llega truncado en el stack local → fix de 3 líneas (solo `old.id`) → retest en verde (INSERT/UPDATE/DELETE en vivo, avatares, consola limpia, a11y, layout). DoD: lint 0 errores / `tsc` 0 / build 0. **Smoke de `db-supabase` parcial:** `list_migrations` + inspección SQL + `gen:types` sin diff.
- **2026-10-14 · Smoke visual #1** — **`chrome-devtools` MCP reactivado** (solo `orchestrator`, `pnpm dlx`) y primer test de navegador end-to-end: login, chat, realtime (INSERT/DELETE entre pestañas), borrado propio, update de perfil y logout — todo verde. Usuario de prueba creado (`tester@chatapp.local`). Nueva deuda registrada (ya resuelta en F2): botón de borrar en mensajes en vivo, avatares rotos por `author`, `console.log` suelto y avisos de accesibilidad.
- **2026-10-14 · Bloque D** — **F1 cerrada.** `refactor` rewireó 11 consumidores de `@/services/*` y `@/features/users/*` a los `index.ts` de `profiles` y `chat` (adaptando firmas: `createMessage({ content })`, `deleteMessage(id)`, `updateProfile(ProfileUpdate)`, `getProfile`, `listProfiles`); `implementer` añadió `isAuthenticated` a `profiles`; el orquestador eliminó `services/` y `features/users/` (aprobado); chat restaurado en `app/page.tsx`. `reviewer` rechazó la primera pasada por build roto (`ProfilesError` en archivo `"use server"`, oculto por caché) → fix en `features/profiles/errors.ts` + `try/catch` de `listProfiles` → **`reviewer: ✅ APROBADO`** con lint/tsc/build en verde.
- **2026-10-14 · Bloque B** — Config multiagente sincronizada: creado **`refactor`** (remoto, arena `app/lib/context/components/services`); `orchestrator` con arena `AGENTS.md` + `.opencode/agents/**`, permiso `subagent: refactor` y `question`; `spec-writer` con modelo local fijo (el free/global falla 3/3) y `webfetch` en `spec-writer`/`reviewer`; `db-supabase` pasa al script `gen:types`; `chrome-devtools` retirado de `opencode.json`. Verificado con `opencode debug agents` (6 agentes) y `debug config`.

> Entradas anteriores rotadas a `docs/archive/2026-10-14-f1-cierre-y-plan-de-revision.md` (Bloque A y Plan de revisión) y `docs/archive/2026-10-09-f05-config-multiagente-y-f1-reconexion.md`.

---

## Siguientes pasos

**F2 — Migrar la UI legacy a los dominios:** ✅ **completada 2026-10-14** (ver "Últimos cambios · F2" y la deuda ya saldada del inventario).

**F3 — Runtime:**

1. Bucket `profiles_avatars` en Studio (usuario); después, si procede, subida de avatar como acción de `features/profiles` (el `app/profile/helps.ts` muerto se borró en F2).
2. Segunda sesión con **otro usuario** en paralelo: el smoke #2 fue a una sola sesión, falta validar realtime entre usuarios distintos (y UPDATE, que no tiene UI).
3. CA-5/P8: ~~reiniciar el stack y re-validar el payload de `DELETE`~~ — **hecho 2026-10-14: no cambió** (`old` sigue siendo `{id}`). Queda decidir P8 (aceptar local y re-validar en cloud; si allí llega completo, re-forzar la validación del hook).
4. Opcional: eliminar la burbuja doble transitoria del envío optimista (cosmética).

**Después:** F4 (specs formales para features nuevas), F5 (testing + re-añadir `chrome-devtools`), encargo real de `db-supabase` (migración de prueba + `db reset`), diagnóstico del fallo de modelo de `spec-writer`, y evaluar skills propias (`sdd-spec-template`, `zod-domain-schemas`, `supabase-rls-realtime`) cuando el flujo ya corra solo.
