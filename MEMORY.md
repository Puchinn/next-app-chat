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
- ⏳ Pendientes de F0.5: probar los agentes con una tarea real; decidir quién edita `app/`, `lib/` y `context/`; escribir las skills propias.
- ⚠️ Código a medio migrar: existe `features/users/` pero el resto vive en `services/` y `components/`.
- ❌ Chat desactivado en `app/page.tsx` (componente `MessagesModule` comentado).
- ❌ Zod no instalado todavía.
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

---

## Deuda y bugs (inventario)

Cada ítem lleva la fase en la que se resuelve.

- [ ] **[F0.5] Probar los agentes con una tarea real.** Ya verificado por comando: orden de permisos (last-match-wins), que el `resource` de `subagent` acepte el nombre del agente, que el `deny` de `.env` del agente vence al `ask` global, que las skills se descubren y que el override de `find-skills` gana. **Falta probar en vivo:** si la salida de `tsc` cabe en el contexto de 72k del `implementer`, y que el shell acotado de `db-supabase` y `reviewer` ejecute los comandos esperados.
- [x] **[F0.5] MCP de Supabase activo** — `enabled: true` en `opencode.json`, bajo `mcp.servers`. `db-supabase` lo habilita con `supabase_* allow` + `webfetch` allow, y niega `supabase_apply_migration` por permiso.
- [ ] **[F0.5] `app/`, `lib/` y `context/` sin agente que los edite** — el orquestador no puede y el `implementer` solo toca `features/`. Decidir: ampliar la arena o sumar un agente con modelo de la nube.
- [x] **[F0.5] Agentes built-in (`build`, `plan`) sin restricciones** — **decisión: se deja así a propósito.** El usuario puede cambiar de agente en la TUI; el MCP y las skills abiertas en `build`/`plan` no se consideran riesgo. Se documenta, no se corrige.
- [ ] **[F0.5] Skills** — instaladas y habilitadas: `supabase` y `supabase-postgres-best-practices` (en `db-supabase`, `reviewer`, `spec-writer`) y `find-skills` (en `orchestrator`). `implementer` queda **sin skills** por diseño. **Pendiente:** `vercel-react-best-practices`; escribir `sdd-spec-template`, `zod-domain-schemas` y `supabase-rls-realtime`.
- [ ] **[F0.5] Nada de F0.5 está commiteado** — `.opencode/`, `.agents/`, `.opencode/skills/`, `opencode.json`, `skills-lock.json`, `supabase/migrations/`, `features/` y `docs/` siguen sin versionar. Un clone nuevo no tiene agentes, skills, MCP ni migraciones. Requiere aprobación explícita.
- [ ] **[F1] `pnpm exec tsc --noEmit` y `pnpm build` FALLAN (4 errores), ya en el commit HEAD** — medido el 2026-10-09. `lib/supabase/client.ts` exporta solo `createClient()`, pero siguen importando `supabaseClient`: `components/testChannel.tsx:3`, `services/authClient.ts:1` y `app/login/page.tsx:40`. Más `testChannel.tsx:32` con `payload` implícito `any`. El build compila bien y falla solo en el typecheck. **Esto bloquea la definición de hecho de cualquier tarea**, así que conviene resolverlo antes de arrancar F1.
- [ ] **[F1] Tabla `profiles` inexistente** — `services/profile.ts` la consulta, pero solo existe `users` en las migraciones. Además falta el bucket `profiles_avatars` (usado en `app/profile/helps.ts`).
- [ ] **[F1] Dos dominios de usuario en conflicto** — `features/users/actions.ts` usa `users`; `services/profile.ts` usa `profiles`. Decisión: unificar en `profiles`.
- [ ] **[F1] Insert roto en mensajes** — `createMessage` (`services/messages.ts`) inserta la columna `author`, que no existe en `messages` (solo `content` y `user_id`). Los inserts fallan.
- [ ] **[F1] RLS de `messages` sin policies** — RLS habilitado pero cero policies → acceso bloqueado para todos.
- [ ] **[F1] Realtime incompleto** — la migración hace `ALTER PUBLICATION supabase_realtime ADD TABLE messages`, pero falta `REPLICA IDENTITY FULL` (los payloads de `DELETE`/`UPDATE` llegarían incompletos).
- [ ] **[F1] Trigger `handle_new_user`** inserta solo `id` y `email` en `users`; al unificar a `profiles` hay que revisarlo.
- [ ] **[F1] Zod no instalado.**
- [ ] **[F2] Tipos duplicados** — la interfaz `Message` está declarada a mano en `components/messagesModule.tsx` y `components/testChannel.tsx`.
- [ ] **[F2] `throw` de strings** — `services/profile.ts` lanza strings en vez de `Error` (ej.: `throw "No se pudo obtener la data"`).
- [ ] **[F2] `services/` + `components/` sin migrar a `features/`.**
- [ ] **[F3] Chat comentado** — `MessagesModule` está deshabilitado en `app/page.tsx`.

---

## Últimos cambios

- **2026-10-09 · F0.5** — **Config multiagente verificada y sincronizada** contra OpenCode v2.0.26 (`opencode debug agents`/`debug config` + doc V2; el schema publicado describe V1 y engaña). Activado el MCP de Supabase con `supabase_* allow` y `supabase_apply_migration` denegado por permiso; `chrome-devtools` movido a `mcp.servers` y cambiado a `pnpm dlx`; `default_agent: orchestrator`. Skills habilitadas por agente (`db-supabase`, `reviewer`, `spec-writer`, `orchestrator`), `implementer` sin skills por diseño; copia propia de `find-skills` en `.opencode/skills/` para usar `pnpm dlx`. Creadas `docs/specs/` y `docs/archive/`. Corregidas 5 desincronizaciones del `MEMORY.md`. **Sin probar en vivo.**
- **2026-10-09 · F0.5** — Creados `spec-writer`, `db-supabase` y `reviewer` en `.opencode/agents/` (heredan el modelo global). `db-supabase` no aplica migraciones (el usuario ejecuta `supabase db reset`) y regenera `database.types.ts`; `reviewer` es de solo lectura y repite la verificación. Ajustados `orchestrator.md` (flujo de migraciones) y `AGENTS.md` (arena de `db-supabase`). El MCP de Supabase sigue apagado. Sin probar en OpenCode.
- **2026-10-09 · F0.5** — Creados `opencode.json`, `.opencode/agents/orchestrator.md` e `.opencode/agents/implementer.md`, adaptados al esquema de OpenCode 2.x de un proyecto previo probado. `AGENTS.md` suma la sección 13 "Agentes y skills" (roles, arenas de edición, veredictos, modelo local, MCP de Supabase sin `apply_migration`, skills).
- **2026-10-09 · F0** — Revisión de `AGENTS.md` y `MEMORY.md`: niveles de aprobación para esquema multiagente, excepciones de arquitectura (realtime, `chat → profiles`), regla de tipos Zod vs `database.types.ts`, definición de hecho, seguridad, git, idioma y testing. Deuda enlazada a fases.

> Entrada rotada a `docs/archive/2026-10-07-f0-creacion-de-la-documentacion.md`.

---

## Siguientes pasos

**F0.5 — Configuración multiagente (en curso):**

1. Probar los cinco agentes con una tarea chica real (ver deuda `[F0.5] Probar los agentes`).
2. Escribir las skills propias (`sdd-spec-template`, `zod-domain-schemas`, `supabase-rls-realtime`) y evaluar `vercel-react-best-practices`.
3. Resolver quién edita `app/`, `lib/` y `context/`.
4. Commit de todo lo untracked (requiere aprobación).

**F1 — Reconexión + cimientos:**

1. Instalar `zod` (previa aprobación).
2. Migración de reconexión Supabase: unificar tabla de usuario en `profiles` + bucket `profiles_avatars` + policies de RLS para `messages` + `REPLICA IDENTITY FULL` + trigger ajustado.
3. Corregir `createMessage` (columna `author` → `user_id`).
4. Generar `database.types.ts` y definir estructura base de `features/` (mover `services/profile.ts` y `services/messages.ts` a sus dominios).

**F2 —** Migrar `services/` + `components/` → `features/`.
**F3 —** Restaurar chat + verificar realtime end-to-end.
**F4 —** Specs formales en `docs/specs/` para features nuevas.
**F5 —** Incorporar testing (la librería se consulta en ese momento).
