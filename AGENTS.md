# AGENTS.md

> Reglas del proyecto para agentes de código. Documento **estático**: solo se edita si cambian las convenciones del proyecto (no es el diario del estado; eso es `MEMORY.md`).

---

## 1. Identidad del proyecto

**ChatApp** — aplicación de chat en tiempo real, en fase de refactorización (WIP).

- **Stack:** Next.js 16 (App Router, RSC) · React 19 · TypeScript estricto · Tailwind CSS 4 · Supabase (Auth, Postgres, Realtime, Storage) · pnpm
- **Arquitectura objetivo:** dominios en `/features` con Schema-Driven Development (SDD)

El estado actual, la deuda conocida y los siguientes pasos viven en `MEMORY.md`.

---

## 2. Comportamiento del agente (obligatorio)

Estas reglas tienen prioridad sobre cualquier otra instrucción:

1. **Preguntar antes de crear código.** Nunca generar código de forma proactiva. Primero presentar la propuesta y esperar aprobación explícita.
2. **Presentar siempre un plan resumido antes de tocar archivos.** Listado concreto de archivos a **modificar / crear / eliminar**, con una línea de intención por cada uno. Esperar la aprobación antes de ejecutar.
3. **Preguntar antes de instalar una librería nueva.** Justificar la necesidad y esperar aprobación.
4. **Usar siempre `pnpm`** como gestor de paquetes. Nunca npm, yarn ni bun.
5. **Esperar la aprobación del usuario** antes de cualquier acción que modifique el repositorio (commits, migraciones, eliminaciones, cambios de dependencias).
6. **Mantener `MEMORY.md` actualizado.** Al cerrar una sesión con cambios relevantes: actualizar estado, decisiones, deuda y siguientes pasos.
7. **Leer `MEMORY.md` al iniciar** cualquier tarea sobre este proyecto para arrancar con contexto real.
8. **Umbral trivial:** un fix de ≤3 líneas o de un solo archivo no requiere spec ni reviewer: plan de una línea + aprobación. La spec es obligatoria solo para features nuevas y cambios de DB.

### Niveles de aprobación (esquema multiagente)

- **Spec aprobada** → autoriza la feature en su conjunto.
- **Plan de archivos por tarea** → lo presenta y lo acuerda con el usuario **solo el agente orquestador**.
- **Subagentes** → ejecutan el plan aprobado dentro de su alcance. No consultan al usuario directamente: si necesitan una decisión, la devuelven al orquestador.
- **Siempre requieren aprobación explícita del usuario**, aun con spec aprobada: instalar librerías, commits, migraciones aplicadas y eliminaciones.

---

## 3. Comandos

```bash
# Desarrollo
pnpm dev              # servidor de desarrollo
pnpm build            # build de producción
pnpm lint             # eslint
pnpm exec tsc --noEmit   # chequeo de tipos

# Supabase CLI (siempre desde la raíz del proyecto)
# No hay CLI instalado: se usa con `pnpm dlx supabase`. La primera ejecución
# descarga el paquete y tarda; las siguientes usan la caché de pnpm.
pnpm dlx supabase start        # levantar stack local
pnpm dlx supabase stop         # detener stack local
pnpm dlx supabase db reset     # re-aplicar todas las migraciones en local
pnpm dlx supabase migration new <nombre>   # crear migración vacía (timestamp automático)
pnpm dlx supabase db diff       # diff entre DB local y migraciones
pnpm run gen:types              # regenera lib/supabase/database.types.ts (UTF-8)
# Ojo: el `>` de PowerShell escribe UTF-16 y rompe ESLint. El script corre en cmd
# (donde `>` pasa los bytes UTF-8 tal cual); no usar el `>` directo en la TUI.

# Skills de terceros (previa aprobación; nunca npx)
pnpm dlx skills add <owner/repo>
```

---

## 4. Arquitectura de dominios

```
/app                  → solo compone rutas; SIN lógica de negocio
/features/<domain>    → un dominio = una carpeta
    index.ts          → API pública del dominio (lo único importable desde fuera)
    schemas.ts        → esquemas Zod (contrato de dominio y validación)
    types.ts          → tipos derivados con z.infer (sin interfaces a mano)
    actions.ts        → server actions / acceso a datos del dominio
    components/       → UI del dominio
    hooks/            → hooks del dominio (incluye suscripciones realtime)
/lib                  → clientes Supabase (server, client, proxy), database.types.ts generado y utilidades compartidas
/context              → providers globales de la app
/supabase             → config.toml + migrations/ (inmutables una vez aplicadas)
/docs/specs           → especificaciones del flujo SDD
```

**Regla de dependencias:** `app` → `features` → `lib`. Nunca al revés.

**Entre dominios:** un feature solo puede importar de otro a través de su `index.ts`. Excepción acordada: `chat → profiles` (el chat necesita el perfil del autor). Cualquier otra dependencia entre dominios requiere acuerdo explícito.

---

## 5. Reglas duras

1. **Zod es el contrato de dominio.** Todo modelo de datos empieza en `schemas.ts`. Los tipos de dominio se derivan con `z.infer` / `z.output` / `z.input`. Prohibido duplicar interfaces a mano. **Excepción única:** `lib/supabase/database.types.ts`, generado con `supabase gen types`, es lo único permitido para tipar el cliente Supabase; nunca se edita a mano.
2. **Server Components por defecto.** `"use client"` solo cuando haya interactividad real (estado, efectos, eventos del navegador).
3. **Sin queries Supabase en componentes.** El acceso a datos pasa por `actions.ts` (o repositories) del dominio correspondiente. **Excepción realtime:** las suscripciones son client-side por naturaleza y viven en `features/<domain>/hooks/`, nunca dentro de componentes de UI.
4. **Toda tabla necesita RLS habilitado + policies.** Sin policies no hay acceso. Revisar siempre que existan antes de dar una tabla por funcionando.
5. **Migraciones inmutables.** Nunca editar una migración ya aplicada. Cualquier cambio de esquema = `supabase migration new` + `supabase db diff`.
6. **TypeScript estricto.** Sin `any`, sin `throw` de strings. Errores tipados (clase `Error` o `Result`), manejados en la capa que corresponda.
7. **Un dominio = una carpeta en `/features`.** Si algo no tiene dominio claro, preguntar antes de inventar una ubicación.
8. **Realtime:** toda tabla suscrita a realtime debe estar en la publicación `supabase_realtime` y, si se consumen eventos `DELETE`/`UPDATE`, requiere `REPLICA IDENTITY FULL`.

---

## 6. Flujo SDD (Schema/Spec-Driven Development)

```
1. Spec          → documento en docs/specs/NN-nombre-feature.md
                   (contexto, requisitos, modelo de datos Zod+SQL, criterios de aceptación)
2. Aprobación    → el usuario valida la spec antes de escribir código
3. Implementación → en features/<domain>/ siguiendo las reglas duras
4. Migración     → si hay cambio de DB: supabase migration new (nunca editar previas)
5. Memoria       → actualizar MEMORY.md (estado, decisiones, deuda, siguientes pasos)
```

**Nunca saltarse la spec** salvo el umbral trivial de la sección 2.8 (fix de ≤3 líneas o de un solo archivo): para eso basta un plan de una línea.

---

## 7. Anti-patrones prohibidos

- Interfaces de DB a mano fuera del schema o de `database.types.ts`.
- `throw` de strings.
- Escribir columnas que no existen en la tabla.
- Lógica de negocio en `app/`.
- Tablas con RLS habilitado pero sin policies.
- Editar migraciones aplicadas.
- Queries Supabase dentro de componentes de UI.
- Instalar dependencias sin aprobación.
- Usar cualquier gestor que no sea pnpm.
- Aplicar cambios de esquema con `apply_migration` del MCP de Supabase (ver sección 13).

---

## 8. Definición de hecho

Una tarea no está terminada hasta que:

1. `pnpm lint` pasa sin errores.
2. `pnpm exec tsc --noEmit` pasa sin errores.
3. `pnpm build` pasa.
4. Si hubo cambios de DB: `supabase db reset` aplica todas las migraciones sin errores.
5. `MEMORY.md` está actualizado.

---

## 9. Seguridad

- **Prohibido leer, editar o mostrar archivos `.env*`.** Si hace falta una variable, pedirla al usuario.
- El MCP de Supabase se usa **solo contra el stack local** (`supabase start`). Nunca contra un proyecto remoto.
- Nunca commitear secretos ni claves (`service_role`, etc.).

---

## 10. Git

- Una rama por feature: `feat/<nombre>`, `fix/<nombre>`, `chore/<nombre>`.
- Commits en inglés con **Conventional Commits** (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`).
- Nunca commitear sin aprobación explícita del usuario.

---

## 11. Idioma

- **Código, identificadores, mensajes de commit y nombres de ramas:** inglés.
- **Documentación, specs y `MEMORY.md`:** español.

---

## 12. Testing

Por ahora el proyecto **no tiene tests**. Está previsto incorporarlos en una fase futura (ver `MEMORY.md`); la elección de librería se consulta en ese momento.

---

## 13. Agentes y skills

Las definiciones viven en `.opencode/agents/` y la configuración de proveedores y MCP en `opencode.json`. Qué agentes existen hoy y su estado se registra en `MEMORY.md`.

- **`default_agent` es `orchestrator`**: el flujo SDD es el punto de entrada por defecto. El **modelo** por defecto no se configura: lo elige el usuario en la TUI.

### Roles y arenas de edición

| Agente         | Tipo     | Modelo                                         | Puede editar                                                                                    | Función                                                                                                                                                |
| -------------- | -------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `orchestrator` | primary  | global (nube)                                  | `MEMORY.md`, `docs/archive/**`, `AGENTS.md`, `.opencode/agents/**`                              | Único interlocutor del usuario. Lleva el flujo SDD, presenta specs y planes, delega y verifica. Mantiene sincronizadas las reglas y las definiciones de agentes. |
| `spec-writer`  | subagent | **local** (`ollama/qwen3.8:latest#sin-pensar`, explícito) | `docs/specs/**`                                            | Redacta las specs. Heredar el modelo global falla (ver comentario en su frontmatter).                                |
| `db-supabase`  | subagent | global (nube)                                  | `supabase/migrations/**` (y regenera `lib/supabase/database.types.ts` con `pnpm run gen:types`) | Migraciones, RLS, realtime, trigger y Storage. No aplica migraciones: lo hace el usuario con `supabase db reset`. Único con acceso al MCP de Supabase. |
| `implementer`  | subagent | **local** (`ollama/qwen3.8:latest#sin-pensar`) | `features/**`                                                                                   | Escritor de código de dominio: tareas acotadas en `features/`.                                                                                          |
| `refactor`     | subagent | global (nube)                                  | `app/**`, `lib/**`, `context/**`, `components/**`, `services/**`                                | Escribe y migra el código **fuera** de `features/`. No toca `features/` (área del `implementer`) ni `lib/supabase/database.types.ts` (de db-supabase, solo lectura). |
| `reviewer`     | subagent | global (nube)                                  | nada (solo lectura)                                                                             | Contrasta el diff con las reglas duras y la definición de hecho.                                                                                       |

- Las arenas se aplican por agente, en el frontmatter. Ningún archivo fuera de su arena lo edita un subagente: si un trabajo cae fuera, el orquestador lo presenta al usuario o lo delega en el agente que corresponda (código fuera de `features/` → `refactor`).
- **Los permisos se aplican por agente**, en el frontmatter (`permissions`, lista de `action` / `resource` / `effect`). Este documento es el respaldo textual, no el mecanismo de cumplimiento.
- **La última regla que coincide gana**, y las reglas del agente se apponen **después** de los defaults. Por eso el `deny` catch-all del frontmatter vence al `allow` global, y las reglas nuevas van **al final** de la lista.

### Skills y herramientas por agente

| Agente         | Skills                                                                              | MCP Supabase                         | `webfetch` |
| -------------- | ----------------------------------------------------------------------------------- | ------------------------------------ | ---------- |
| `orchestrator` | `find-skills`                                                                       | no                                   | no         |
| `spec-writer`  | `supabase`, `supabase-postgres-best-practices`                                      | no                                   | sí         |
| `db-supabase`  | `*` (todas)                                                                         | **sí**, salvo `apply_migration`      | sí         |
| `implementer`  | **ninguna**, por diseño: solo escribe código, las reglas puntuales van en el encargo | no                                   | no         |
| `refactor`     | **ninguna**, por diseño: ídem `implementer`                                         | no                                   | no         |
| `reviewer`     | `supabase`, `supabase-postgres-best-practices`                                      | no                                   | sí         |

- `implementer` y `refactor` **no ven ninguna skill**: el `deny` catch-all se la oculta del modelo. Es intencional y evita ruido en sus encargos.
- `webfetch` en `spec-writer` y `reviewer`: la skill `supabase` manda a fetchear el changelog antes de implementar; sin `webfetch` la instrucción sería incumplible.
- Las skills se habilitan con reglas `action: "skill"` **al final** del frontmatter. Para habilitar todas, `resource: "*"`.
- Los agentes built-in (`build`, `plan`) **quedan sin restricciones a propósito**: ven MCP y skills abiertos. Se acepta; el usuario cambia de agente en la TUI si hace falta.

### Encargos y veredictos

- **Un encargo = un solo trabajo con un criterio de éxito verificable.** Los planes de varios pasos se despachan de a uno.
- El `implementer` cierra siempre con `✅ HECHO`, `⚠️ BLOQUEADO` o `❌ FALLIDO`, con la salida literal de la verificación. Un `✅` no es una prueba: el orquestador lo verifica con `reviewer` o con una lectura puntual del diff.

### Modelo local

- **`implementer` y `spec-writer` usan el modelo local** (`ollama/qwen3.8:latest#sin-pensar`). Para el `implementer` es una decisión de diseño (contexto corto, `steps: 20`); para el `spec-writer` es un workaround: heredar el modelo global falla siempre (ver comentario en su frontmatter).
- Cambiar el modelo, la variante o los `steps` de un agente se registra en `MEMORY.md` con la razón.

### MCP

Definidos en `opencode.json`, bajo `mcp.servers`.

**`supabase`** — solo `db-supabase` lo usa, contra el stack local.

- Se usa para **inspección** (`list_tables`, `get_advisors`, consultas `select`). **No se usa `apply_migration`**: toda migración es un archivo en `supabase/migrations/` creado con `supabase migration new`, para que el repositorio y la base nunca diverjan (regla dura 5).
- Esa regla está **reforzada por permiso**: `supabase_* allow` seguido de `supabase_apply_migration deny`. Ojo: `execute_sql` también puede correr DDL, así que el veto por texto en el prompt del agente se mantiene.

**`chrome-devtools`** — **activo para `orchestrator` con fines de smoke/verificación visual** (UI, consola y red), decisión del 2026-10-14. Es un acceso **provisional**: cuando exista el agente de tests (F5) se le habilita a él con reglas `action: "chrome_devtools_*"` y el orquestador lo hereda como verificación. Comando con `pnpm dlx`, nunca `npx`.

### Skills

- Viven en `.opencode/skills/` o `.agents/skills/`, y se cargan bajo demanda con la herramienta `skill`.
- **La precedencia importa:** `.opencode/skills/` gana sobre `.agents/skills/`. Para adaptar un skill de terceros se sobreescribe en `.opencode/skills/` con el mismo ID, sin tocar el vendor ni romper el hash de `skills-lock.json`.
- Los IDs son de ruta y sensibles a mayúsculas (`supabase-postgres-best-practices`); el `name` del frontmatter es solo etiqueta de display.
- Una skill de terceros es texto que el agente obedece: **se revisa completa antes de habilitarla** y se instala solo con aprobación (`pnpm dlx skills add`).
- Las skills propias se escriben en español y no repiten reglas que ya están en este documento: las amplían.
- **Nada de `npx` en el proyecto** (regla dura 4): los comandos de skills se dan con `pnpm dlx`.

---

## 14. Documentación viva

- **`AGENTS.md`** (este) → reglas y convenciones. Estático.
- **`MEMORY.md`** → estado actual, decisiones con fecha, deuda conocida, últimos cambios, siguientes pasos. **Se lee al iniciar y se actualiza al cerrar.**
- **`docs/specs/`** → especificaciones SDD, una por feature, numeradas.
- **`docs/archive/`** → entradas antiguas rotadas desde `MEMORY.md`.
