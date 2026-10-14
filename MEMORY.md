# MEMORY.md

> **Diario del proyecto.** Se lee al iniciar cada tarea y se actualiza al cerrar cada sesión con cambios relevantes.
> Reglas y convenciones → ver `AGENTS.md`.
> Mantener corto: en "Últimos cambios" solo las últimas 3 a 5 entradas; lo anterior se rota a `docs/archive/`.

---

## Estado actual

**Fecha de actualización:** 2026-10-09
**Fase:** F0 completada (documentación base). **F0.5 en curso** (configuración multiagente). Próxima: F1.

- ✅ `AGENTS.md` y `MEMORY.md` creados y revisados; `AGENTS.md` incluye la sección 13 "Agentes y skills".
- ✅ Versión funcional previa con Supabase corriendo fuera del proyecto; hoy migrado a Supabase CLI con carpeta `supabase/` propia (`config.toml` + 1 migración de estado actual).
- ✅ Config multiagente **verificada en OpenCode v2.0.26** con `opencode debug agents` y `opencode debug config`: los 5 agentes cargan, los permisos se parsean y aplican, las skills se descubren y el override funciona.
- ✅ `opencode.json`: provider `ollama` con variantes, `default_agent: orchestrator`, MCP de Supabase **activo** y `chrome-devtools` **reservado a tests** (nadie lo usa todavía).
- ✅ Skills instaladas en `.agents/skills/`: `supabase`, `supabase-postgres-best-practices`, `find-skills`. Copia propia de `find-skills` en `.opencode/skills/` (precedencia más alta) para usar `pnpm dlx`.
- ✅ **Stack local levantado, migraciones aplicadas** (DB 54322, API/MCP 54321) y `lib/supabase/database.types.ts` regenerado. Contrato real: `profiles(avatar_url, created_at, email, full_name, id, username)` y `messages(content, created_at, id, user_id)` con FK a `profiles`. La tabla `users` **ya no existe**.
- ✅ **F1 implementada en `features/`:** dominios `profiles/` y `chat/` con Zod como contrato, errores tipados, y hook realtime `useMessagesRealtime`.
- ✅ **`zod` 4.6.5 instalado** (aprobado por el usuario el 2026-10-09).
- ⏳ Pendientes de F0.5: probar los agentes con una tarea real; decidir quién edita `app/`, `lib/` y `context/`; escribir las skills propias.
- 🚫 **`spec-writer` necesita modelo explícito.** Con el modelo global heredado falla siempre con `OpenCode's free tier can only be used from within OpenCode` (probado foreground, background y con encargo mínimo). Con `ollama/qwen3.8:latest#sin-pensar` funciona. `reviewer`, `implementer` y `db-supabase` sí heredan el global sin problema. Pendiente de diagnosticar la causa; workaround: pasarle `model` en cada invocación.
- ⚠️ Código a medio migrar: existe `features/users/` pero el resto vive en `services/` y `components/`.
- ❌ Chat desactivado en `app/page.tsx` (componente `MessagesModule` comentado).
- ❌ `lib/supabase/database.types.ts` se generó en **UTF-16** (PowerShell con `>`), por eso ESLint lo lee como binario y `pnpm lint` falla con 1 error. Regenerarlo en UTF-8.
- ❌ Varios bugs de desconexión listados en "Deuda y bugs" (bloquean el funcionamiento real).

---

## Decisiones

| Fecha      | Decisión                                                                                                                                                                                                                                                                                              |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-10-07 | Documentación del proyecto en **español**.                                                                                                                                                                                                                                                            |
| 2026-10-07 | Unificar los dominios de usuario (`users` + `profiles` inexistente) en una sola tabla **`profiles`** (convención estándar de Supabase). `features/users/` se adaptará hacia `features/profiles/`.                                                                                                     |
| 2026-10-07 | Las specs SDD viven en **`docs/specs/`**, numeradas (`NN-nombre-feature.md`).                                                                                                                                                                                                                         |
| 2026-10-07 | Flujo de trabajo: siempre plan resumido (archivos a modificar/crear/eliminar) + aprobación antes de escribir código o instalar librerías. Siempre `pnpm`.                                                                                                                                             |
| 2026-10-09 | Idioma: código, identificadores, commits y ramas en **inglés**; docs y specs en **español**.                                                                                                                                                                                                          |
| 2026-10-09 | Commits con **Conventional Commits**.                                                                                                                                                                                                                                                                 |
| 2026-10-09 | Sin tests por ahora; se incorporan en una fase futura (F5).                                                                                                                                                                                                                                           |
| 2026-10-09 | Aprobaciones en dos niveles: spec aprobada autoriza la feature; el plan de archivos por tarea lo acuerda solo el orquestador con el usuario; los subagentes no consultan directo.                                                                                                                     |
| 2026-10-09 | Zod = contrato de dominio; `database.types.ts` generado con `supabase gen types` = único tipado permitido del cliente Supabase.                                                                                                                                                                       |
| 2026-10-09 | Las reglas se hacen cumplir con permisos y no solo con texto. _Precisada abajo: los permisos viven en el frontmatter de cada agente._                                                                                                                                                                 |
| 2026-10-09 | Excepciones de arquitectura: suscripciones realtime en `features/<domain>/hooks/`; `chat → profiles` solo vía `index.ts` público.                                                                                                                                                                     |
| 2026-10-09 | **Esquema de OpenCode 2.x** tomado de un proyecto previo ya probado (`permissions` como lista de `action`/`resource`/`effect`, `providers.ollama` con `variants`, `mcp.servers`), porque difiere de las docs públicas consultadas.                                                                    |
| 2026-10-09 | ~~**Sin permisos globales en `opencode.json`:** su sintaxis no está verificada en 2.x.~~ **Corregido:** `permissions` global sí es V2 documentado (lista de `action`/`resource`/`effect`). Se decidió **no usarlo**: `build`/`plan` quedan con MCP y skills abiertos a propósito.                                                                                                            |
| 2026-10-09 | **Solo el `implementer` usa modelo local** (`ollama/qwen3.8:latest#sin-pensar`, `steps: 20`). El orquestador, `spec-writer`, `db-supabase` y `reviewer` heredan el modelo global (nube). Si se quiere fijar otro modelo en alguno, se habla antes.                                                    |
| 2026-10-09 | Variante **`#sin-pensar` por defecto** (`think: false` + `reasoning_effort: "none"`): el endpoint de Ollama compatible con OpenAI ignora `think` y solo respeta `reasoning_effort`. Dato medido en el proyecto previo (6/6 tareas mecánicas aprobadas en esa modalidad).                              |
| 2026-10-09 | El `implementer` edita solo `features/**` y su shell se limita a `pnpm exec tsc --noEmit` y `pnpm exec eslint *`.                                                                                                                                                                                     |
| 2026-10-09 | **MCP de Supabase solo para inspección**; no se usa `apply_migration`. Las migraciones son archivos creados con `supabase migration new`. Motivo: en el proyecto previo `apply_migration` dejó la base y el repositorio desincronizados y hubo que crear el `.sql` a mano.                            |
| 2026-10-09 | **`db-supabase` no aplica migraciones:** su shell no incluye `supabase db reset`. El usuario aprueba y ejecuta `supabase db reset`; después `db-supabase` regenera `database.types.ts`. Motivo: aplicar una migración exige aprobación del usuario y no está verificado que 2.x admita `effect: ask`. |
| 2026-10-09 | **`reviewer` de solo lectura**, con shell limitado a `git status/diff/log`, `pnpm lint`, `pnpm exec tsc --noEmit` y `pnpm build`. No confía en la verificación declarada por el agente que hizo el trabajo: la repite.                                                                                |
| 2026-10-09 | **`https://opencode.ai/config.json` describe V1, no V2.** La skill de OpenCode lo advierte. La fuente de verdad es `https://opencode.ai/v2/docs/`. Verificado con `opencode debug agents` / `debug config`, no por el schema.                                                                        |
| 2026-10-09 | **Permisos: la última regla que coincide gana**, y las reglas del agente se apponen **después** de los defaults. Por eso el catch-all `deny` de cada agente sí vence, y el `deny` de `.env` del agente vence al `ask` global. Verificado empíricamente.                                              |
| 2026-10-09 | **`default_agent: orchestrator`** en `opencode.json`, para que el flujo SDD sea el punto de entrada por defecto en vez de `build`. El modelo por defecto **no** se define: lo elige el usuario en la TUI. Solo el `implementer` lleva `model` explícito.                                              |
| 2026-10-09 | **`apply_migration` denegado por permiso**, no solo por texto: `supabase_* allow` seguido de `supabase_apply_migration deny` en `db-supabase`. Caveat honesto: `execute_sql` también puede correr DDL, así que la regla por prompt se mantiene.                                                    |
| 2026-10-09 | **`implementer` sin skills**: solo escupe código, las reglas puntuales se pasan en el encargo. Su catch-all `deny` ya le oculta las skills del modelo. **`reviewer` informado**: sí skills de Postgres.                                                                                             |
| 2026-10-09 | **`chrome-devtools` reservado a un agente de tests futuro.** Está en `mcp.servers` pero ningún agente propio lo tiene permitido (el catch-all `deny` lo bloquea). Se habilita cuando exista ese agente.                                                                                               |
| 2026-10-09 | **Nada de `npx` en el repo.** El MCP y la copia propia de `find-skills` usan `pnpm dlx`. Para skills de terceros que haya que adaptar, se sobreescribe en `.opencode/skills/` (precedencia más alta) en vez de parchear el vendor y romper el hash del lock.                                          |
| 2026-10-09 | **CLI de Supabase vía `pnpm dlx supabase ...`**, nunca global ni con `npx` (verificado con la 2.120.0). Ojo: la allowlist del shell de cada agente es **literal**, así que hay que llevarla con el mismo prefijo o los comandos quedan denegados.                                                 |
| 2026-10-09 | **Arena del `implementer` ampliada a `app/`, `lib/` y `context/`** (decisión del orquestador, delegada por el usuario). Motivo: sin esto no se pueden tocar los 4 errores de `tsc` ni la migración `services/` → `features/`, que tocan imports en `app/`. Se mantiene modelo local y encargos de una sola tarea. **Pendiente de aplicar** en `.opencode/agents/implementer.md`, fuera de la arena del orquestador. |
| 2026-10-09 | **Zod 4: sin helpers de formato en los schemas.** En Zod 4 `.email()`, `.uuid()`, `.url()` y `.datetime()` se movieron o deprecaron; para no arriesgar el typecheck con el modelo local los schemas usan `z.string()` puro y la validación de formato la hace la DB, que es la fuente de verdad.                                                                                                                          |
| 2026-10-09 | **`spec-writer` necesita `model` explícito en cada invocación** (`ollama/qwen3.8:latest#sin-pensar`). Con el modelo global heredado falla siempre con `OpenCode's free tier can only be used from within OpenCode`; los demás agentes heredan el global sin problema. Causa raíz sin diagnosticar.                                                                                                                                                |

---

## Deuda y bugs (inventario)

Cada ítem lleva la fase en la que se resuelve.

- [ ] **[F0.5] Probar los agentes con una tarea real.** Ya verificado por comando: orden de permisos (last-match-wins), que el `resource` de `subagent` acepte el nombre del agente, que el `deny` de `.env` del agente vence al `ask` global, que las skills se descubren y que el override de `find-skills` gana. **Falta probar en vivo:** si la salida de `tsc` cabe en el contexto de 72k del `implementer`, y que el shell acotado de `db-supabase` y `reviewer` ejecute los comandos esperados.
- [x] **[F0.5] MCP de Supabase activo** — `enabled: true` en `opencode.json`, bajo `mcp.servers`. `db-supabase` lo habilita con `supabase_* allow` + `webfetch` allow, y niega `supabase_apply_migration` por permiso.
- [ ] **[F0.5] `app/`, `lib/` y `context/` sin agente que los edite** — **decidido 2026-10-09: ampliar la arena del `implementer`** (ver Decisiones). Falta aplicar el cambio en `.opencode/agents/implementer.md`, que está fuera de la arena del orquestador.
- [x] **[F0.5] Agentes built-in (`build`, `plan`) sin restricciones** — **decisión: se deja así a propósito.** El usuario puede cambiar de agente en la TUI; el MCP y las skills abiertas en `build`/`plan` no se consideran riesgo. Se documenta, no se corrige.
- [ ] **[F0.5] Skills** — instaladas y habilitadas: `supabase` y `supabase-postgres-best-practices` (en `db-supabase`, `reviewer`, `spec-writer`) y `find-skills` (en `orchestrator`). `implementer` queda **sin skills** por diseño. **Pendiente:** `vercel-react-best-practices`; escribir `sdd-spec-template`, `zod-domain-schemas` y `supabase-rls-realtime`.
- [x] **[F0.5] F0.5 commiteado** — `1379c8e` (config, agentes, skills, MCP, docs) y `c3d5c5b` (migración inicial y `features/`). **Quedó sin commitear el WIP del usuario** en `app/`, `services/`, `components/` y `package.json`: sin relación con F0.5 y con `tsc` roto.
- [x] **[F0.5] CLI de Supabase** — no está instalado (verificado: ni global, ni scoop/winget/npm, ni local). **Decisión: no instalar nada global; usar `pnpm dlx supabase ...`**, consistente con la regla dura 4. Verificado el 2026-10-09: `pnpm dlx supabase --version` → `2.120.0`, exit 0, 491 ms. Actualizados `AGENTS.md` (sección 3) y la allowlist del shell de `db-supabase`, que es literal y dejaba de coincidir con el prefijo nuevo.
- [ ] **[F1] `pnpm exec tsc --noEmit` y `pnpm build` FALLAN (4 errores), ya en el commit HEAD** — medido el 2026-10-09. `lib/supabase/client.ts` exporta solo `createClient()`, pero siguen importando `supabaseClient`: `components/testChannel.tsx:3`, `services/authClient.ts:1` y `app/login/page.tsx:40`. Más `testChannel.tsx:32` con `payload` implícito `any`. El build compila bien y falla solo en el typecheck. **Esto bloquea la definición de hecho de cualquier tarea**, así que conviene resolverlo antes de arrancar F1.
- [x] **[F1] Tabla `profiles` inexistente** — creada y unificada con `users` en la migración `20261009235112_reconexion_profiles_messages.sql`. Bucket `profiles_avatars`: policies de Storage listas, **falta que el usuario cree el bucket** (es runtime).
- [x] **[F1] Dos dominios de usuario en conflicto** — unificados en `profiles`. `features/users/` sigue existiendo: queda eliminarlo al rewirear los consumidores.
- [x] **[F1] Insert roto en mensajes** — `createMessage` ahora escribe `user_id`, nunca `author`.
- [x] **[F1] RLS de `messages` sin policies** — 4 policies creadas (`select_all`, `insert_own`, `update_own`, `delete_own`).
- [x] **[F1] Realtime incompleto** — `REPLICA IDENTITY FULL` agregado.
- [x] **[F1] Trigger `handle_new_user`** — reescrito para insertar en `profiles`, idempotente.
- [x] **[F1] Zod no instalado** — 4.6.5.
- [ ] **[F1] Rewirear consumidores de `services/` y `features/users/`** — 8 archivos en `context/`, `components/` y `app/` siguen importando `services/profile`, `services/messages`, `services/auth` y `features/users`. Requiere **ampliar la arena del `implementer`** (decisión ya tomada, sin aplicar).
- [ ] **[F1] `database.types.ts` en UTF-16** — bloquea `pnpm lint`.
- [ ] **[F1] Bucket `profiles_avatars`** — el usuario lo crea a mano en Studio.
- [ ] **[F2] Tipos duplicados** — la interfaz `Message` está declarada a mano en `components/messagesModule.tsx` y `components/testChannel.tsx`.
- [ ] **[F2] `throw` de strings** — `services/profile.ts` lanza strings en vez de `Error` (ej.: `throw "No se pudo obtener la data"`).
- [ ] **[F2] `services/` + `components/` sin migrar a `features/`.**
- [ ] **[F3] Chat comentado** — `MessagesModule` está deshabilitado en `app/page.tsx`.

---

## Últimos cambios

- **2026-10-09 · F1** — **Spec `docs/specs/01-reconexion-supabase.md` aprobada e implementada en `features/`.** Migración `20261009235112_reconexion_profiles_messages.sql` (aplicada con `db reset`): unifica `users` → `profiles` conservando datos, 4 policies de RLS en `profiles` y 4 en `messages` (antes cero), `REPLICA IDENTITY FULL`, trigger idempotente, índice y grants. Creados los dominios `profiles/` (schemas, types, actions, index) y `chat/` (idem + `errors.ts` + hook `useMessagesRealtime`), con Zod como contrato y errores tipados. Zod 4.6.5 instalado. Corregidos en el camino: destructuring de `auth.getUser()`, `ChatError` fuera del archivo `"use server"` (rompía en F3) y `.max(4000)` en `content`. **Falta:** rewirear los 8 consumidores de `services/` y `features/users/` (bloqueado por la arena del `implementer`), regenerar `database.types.ts` en UTF-8 y crear el bucket `profiles_avatars`.
- **2026-10-09 · F0.5** — **Config multiagente verificada y sincronizada** contra OpenCode v2.0.26 (`opencode debug agents`/`debug config` + doc V2; el schema publicado describe V1 y engaña). Activado el MCP de Supabase con `supabase_* allow` y `supabase_apply_migration` denegado por permiso; `chrome-devtools` movido a `mcp.servers` y cambiado a `pnpm dlx`; `default_agent: orchestrator`. Skills habilitadas por agente (`db-supabase`, `reviewer`, `spec-writer`, `orchestrator`), `implementer` sin skills por diseño; copia propia de `find-skills` en `.opencode/skills/` para usar `pnpm dlx`. Creadas `docs/specs/` y `docs/archive/`. Corregidas 5 desincronizaciones del `MEMORY.md`. Commiteado en `1379c8e` + `c3d5c5b` (el WIP de `app/`, `services/` y `components/` quedó fuera). CLI de Supabase: no instalado, se usa con `pnpm dlx supabase` (`2.120.0`), allowlist del shell de `db-supabase` actualizada porque es literal. Stack local levantado, migración aplicada y generado `database.types.ts`.
- **2026-10-09 · F0.5** — Creados `spec-writer`, `db-supabase` y `reviewer` en `.opencode/agents/` (heredan el modelo global). `db-supabase` no aplica migraciones (el usuario ejecuta `supabase db reset`) y regenera `database.types.ts`; `reviewer` es de solo lectura y repite la verificación. Ajustados `orchestrator.md` (flujo de migraciones) y `AGENTS.md` (arena de `db-supabase`). El MCP de Supabase sigue apagado. Sin probar en OpenCode.
- **2026-10-09 · F0.5** — Creados `opencode.json`, `.opencode/agents/orchestrator.md` e `.opencode/agents/implementer.md`, adaptados al esquema de OpenCode 2.x de un proyecto previo probado. `AGENTS.md` suma la sección 13 "Agentes y skills" (roles, arenas de edición, veredictos, modelo local, MCP de Supabase sin `apply_migration`, skills).
- **2026-10-09 · F0** — Revisión de `AGENTS.md` y `MEMORY.md`: niveles de aprobación para esquema multiagente, excepciones de arquitectura (realtime, `chat → profiles`), regla de tipos Zod vs `database.types.ts`, definición de hecho, seguridad, git, idioma y testing. Deuda enlazada a fases.

> Entrada rotada a `docs/archive/2026-10-07-f0-creacion-de-la-documentacion.md`.

---

## Siguientes pasos

**F0.5 — Configuración multiagente (en curso):**

1. Levantar el stack local (`pnpm dlx supabase start`) y aplicar la migración (`pnpm dlx supabase db reset`), para después generar `database.types.ts`.
2. Probar los cinco agentes con una tarea chica real (ver deuda `[F0.5] Probar los agentes`).
3. Escribir las skills propias (`sdd-spec-template`, `zod-domain-schemas`, `supabase-rls-realtime`) y evaluar `vercel-react-best-practices`.
4. Resolver quién edita `app/`, `lib/` y `context/`.
5. **Arreglar los 4 errores de `tsc`** (`supabaseClient`): bloquean la definición de hecho de cualquier tarea.

**F1 — Reconexión + cimientos:**

1. Instalar `zod` (previa aprobación).
2. Migración de reconexión Supabase: unificar tabla de usuario en `profiles` + bucket `profiles_avatars` + policies de RLS para `messages` + `REPLICA IDENTITY FULL` + trigger ajustado.
3. Corregir `createMessage` (columna `author` → `user_id`).
4. Generar `database.types.ts` y definir estructura base de `features/` (mover `services/profile.ts` y `services/messages.ts` a sus dominios).

**F2 —** Migrar `services/` + `components/` → `features/`.
**F3 —** Restaurar chat + verificar realtime end-to-end.
**F4 —** Specs formales en `docs/specs/` para features nuevas.
**F5 —** Incorporar testing (la librería se consulta en ese momento).
