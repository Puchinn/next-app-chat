# MEMORY.md

> **Diario del proyecto.** Se lee al iniciar cada tarea y se actualiza al cerrar cada sesión con cambios relevantes.
> Reglas y convenciones → ver `AGENTS.md`.
> Mantener corto: en "Últimos cambios" solo las últimas 3 a 5 entradas; lo anterior se rota a `docs/archive/`.

---

## Estado actual

**Fecha de actualización:** 2026-10-14
**Fase:** F1 completada (dominios + rewire + eliminación de legacy). Config multiagente (F0.5) completada. Próxima: F2.

- ✅ **Definición de hecho en verde** (verificado 2026-10-14): `pnpm lint` 0 errores (4 warnings preexistentes), `pnpm exec tsc --noEmit` exit 0, `pnpm build` exit 0.
- ✅ **Rama `chore/agent-rework`** con 4 commits: WIP snapshot (`cb5d61c`), fix de bloqueos (`0042aba`), config de agentes (`c2af16c`) y rewire (`a12b9e4`). **Sin merge a `main`.**
- ✅ **Config multiagente: 6 agentes** (`orchestrator`, `spec-writer`, `db-supabase`, `implementer`, `refactor`, `reviewer`), arenas y modelos sincronizados con `AGENTS.md` §13.
- ✅ **`services/` y `features/users/` eliminados.** Los 11 consumidores rewireados a `@/features/profiles` y `@/features/chat` (solo vía `index.ts`). `features/users/actions.ts` consultaba la tabla `users`, inexistente desde la migración: las páginas de perfil estaban rotas en runtime y ahora usan `profiles`.
- ✅ **Chat restaurado** en `app/page.tsx` (`MessagesModule` vuelve a renderizar).
- ✅ **`pnpm run gen:types`** regenera `database.types.ts` en UTF-8 (el `>` de PowerShell escribía UTF-16 y ESLint lo leía como binario).
- ✅ **Spec 01 sincronizada** con el código (nombre del hook, CA-9, comando de tipos, deuda de `tsc` saldada).
- ⏳ **Runtime sin verificar:** el chat end-to-end (realtime) y el bucket `profiles_avatars` se prueban en navegador/Studio (F3).
- ⚠️ **Deuda F2 conocida:** interfaces `Message` a mano en `messagesModule`/`modernListMessages`/`testChannel`/`listMessages` (usan `author`, columna que ya no existe: migrar a `user_id` + perfil del autor), `throw "..."` en `app/profile/helps.ts:21`, suscripción realtime dentro de `testChannel.tsx` (el hook `useMessagesRealtime` existe y no está enchufado).

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
| 2026-10-14 | **`ProfilesError` vive en `features/<dominio>/errors.ts`**, nunca exportada desde un archivo `"use server"` (Turbopack descarta el módulo entero; el fallo estaba oculto por la caché del build).                                                                                   |

---

## Deuda y bugs (inventario)

Cada ítem lleva la fase en la que se resuelve.

- [x] **[F1] `tsc`/`build`/lint rotos** — resueltos 2026-10-14: `supabaseClient` → `createClient()`, `database.types.ts` en UTF-8 vía `pnpm run gen:types`, y `ProfilesError` movida a `features/profiles/errors.ts` (causa real de los 21 errores de build).
- [x] **[F1] Rewirear consumidores de `services/` y `features/users/`** — hecho (11 archivos); `services/` y `features/users/` eliminados.
- [x] **[F0.5] Arena de `app/`, `lib/` y `context/`** — resuelto con el agente `refactor` (remoto), no ampliando al `implementer`.
- [ ] **[F0.5] Smoke test de los 6 agentes** — parcial: `refactor` (3 encargos ✓), `implementer` (2 ✓), `spec-writer` (1 ✓ con modelo local), `reviewer` (2 ✓). **Falta `db-supabase`** en vivo (crear una migración de prueba o regenerar tipos tras un `db reset`).
- [ ] **[F0.5] Causa raíz del fallo de modelo de `spec-writer`** — sigue sin diagnosticarse; workaround fijado en el frontmatter.
- [ ] **[F2] `interface Message` a mano** en `messagesModule`, `modernListMessages`, `testChannel` y `listMessages`: usan `author` (columna inexistente). Migrar la UI a `user_id` + perfil del autor (`MessageWithAuthor`). Intentado 2026-10-14: requiere reescritura de UI, no un swap de tipos.
- [ ] **[F2] `throw "Error al subir la imagen"`** en `app/profile/helps.ts:21`.
- [ ] **[F2] Realtime enchufado a hooks:** `testChannel.tsx` suscribe realtime dentro del componente (regla dura 3); `useMessagesRealtime` existe sin usar. Clarificar el rol de `testChannel` vs `messagesModule` (posible borrado).
- [ ] **[F3] Verificar chat end-to-end en runtime** (2 sesiones, insert/update/delete en realtime). Sin tests automatizados.
- [ ] **[F3] Bucket `profiles_avatars`** — el usuario lo crea en Studio (policies de Storage ya escritas en la migración).
- [ ] **[F5] Testing** (librería a consultar en su momento) y re-añadir `chrome-devtools`.

---

## Últimos cambios

- **2026-10-14 · Bloque D** — **F1 cerrada.** `refactor` rewireó 11 consumidores de `@/services/*` y `@/features/users/*` a los `index.ts` de `profiles` y `chat` (adaptando firmas: `createMessage({ content })`, `deleteMessage(id)`, `updateProfile(ProfileUpdate)`, `getProfile`, `listProfiles`); `implementer` añadió `isAuthenticated` a `profiles`; el orquestador eliminó `services/` y `features/users/` (aprobado); chat restaurado en `app/page.tsx`. `reviewer` rechazó la primera pasada por build roto (`ProfilesError` en archivo `"use server"`, oculto por caché) → fix en `features/profiles/errors.ts` + `try/catch` de `listProfiles` → **`reviewer: ✅ APROBADO`** con lint/tsc/build en verde.
- **2026-10-14 · Bloque B** — Config multiagente sincronizada: creado **`refactor`** (remoto, arena `app/lib/context/components/services`); `orchestrator` con arena `AGENTS.md` + `.opencode/agents/**`, permiso `subagent: refactor` y `question`; `spec-writer` con modelo local fijo (el free/global falla 3/3) y `webfetch` en `spec-writer`/`reviewer`; `db-supabase` pasa al script `gen:types`; `chrome-devtools` retirado de `opencode.json`. Verificado con `opencode debug agents` (6 agentes) y `debug config`.
- **2026-10-14 · Bloque A** — Desbloqueada la definición de hecho: script `gen:types` en `package.json` (UTF-8) + tipos regenerados; `refactor` corrigió los 4 errores de `tsc` (`supabaseClient` → `createClient`, payload realtime tipado); spec 01 actualizada por `spec-writer`.
- **2026-10-14 · Plan de revisión** — Auditoría completa de agentes, docs, skills y MCP: 6 inconsistencias duras (fase desactualizada, arena decidida sin aplicar, `spec-writer` sin modelo, comando `>` UTF-16 documentado en 3 sitios, `webfetch` faltante en skills de Supabase, `MEMORY.md` fuera de su propia regla de longitud). Plan aprobado y ejecutado en los bloques A–D.

> Entradas anteriores rotadas a `docs/archive/2026-10-09-f05-config-multiagente-y-f1-reconexion.md`.

---

## Siguientes pasos

**F2 — Migrar la UI legacy a los dominios:**

1. `interface Message` con `author` → `Message`/`MessageWithAuthor` de `@/features/chat` (migrar fallback de avatar y mensaje optimista a `user_id` + perfil).
2. `throw "..."` en `app/profile/helps.ts` → errores tipados del dominio profiles.
3. Realtime: enchufar `useMessagesRealtime` y aclarar el rol de `testChannel.tsx` (borrarlo si es redundante con `messagesModule`).

**F3 — Runtime:**

1. `pnpm dev` + 2 sesiones: verificar insert/update/delete en realtime y el flujo de login → chat → perfil.
2. Bucket `profiles_avatars` en Studio (usuario).

**Después:** F4 (specs formales para features nuevas), F5 (testing + re-añadir `chrome-devtools`), smoke de `db-supabase`, diagnóstico del fallo de modelo de `spec-writer`, y evaluar skills propias (`sdd-spec-template`, `zod-domain-schemas`, `supabase-rls-realtime`) cuando el flujo ya corra solo.
