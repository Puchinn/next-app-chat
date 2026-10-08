# AGENTS.md

> Reglas del proyecto para agentes de código. Documento **estático**: solo se edita si cambian las convenciones del proyecto (no es el diario del estado; eso es `MEMORY.md`).

---

## 1. Identidad del proyecto

**ChatApp** — aplicación de chat en tiempo real, en fase de refactorización (WIP).

- **Stack:** Next.js 16 (App Router, RSC) · React 19 · TypeScript estricto · Tailwind CSS 4 · Supabase (Auth, Postgres, Realtime, Storage) · pnpm
- **Arquitectura objetivo:** dominios en `/features` con Schema-Driven Development (SDD)
- **Estado:** versión funcional previa con Supabase corriendo fuera del proyecto; hoy migrado a Supabase CLI con carpeta `supabase/` propia (historial de migraciones). Quedan cosas desconectadas: ver `MEMORY.md`.

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

---

## 3. Comandos

```bash
# Desarrollo
pnpm dev              # servidor de desarrollo
pnpm build            # build de producción
pnpm lint             # eslint

# Supabase CLI (siempre desde la raíz del proyecto)
supabase start        # levantar stack local
supabase stop         # detener stack local
supabase db reset     # re-aplicar todas las migraciones en local
supabase migration new <nombre>   # crear migración vacía (timestamp automático)
supabase db diff       # diff entre DB local y migraciones
```

---

## 4. Arquitectura de dominios

```
/app                  → solo compone rutas; SIN lógica de negocio
/features/<domain>    → un dominio = una carpeta
    schemas.ts        → esquemas Zod (fuente de verdad)
    types.ts          → tipos derivados con z.infer (sin interfaces a mano)
    actions.ts        → server actions / acceso a datos del dominio
    components/       → UI del dominio
    hooks/            → hooks del dominio
/lib                  → clientes Supabase (server, client, proxy) y utilidades compartidas
/context              → providers globales de la app
/supabase             → config.toml + migrations/ (inmutables una vez aplicadas)
/docs/specs           → especificaciones del flujo SDD
```

**Regla de dependencias:** `app` → `features` → `lib`. Nunca al revés. Un feature no importa de otro feature salvo acuerdos explícitos.

---

## 5. Reglas duras

1. **Zod es la fuente de verdad.** Todo modelo de datos empieza en `schemas.ts`. Los tipos se derivan con `z.infer` / `z.inferOut`. Prohibido duplicar interfaces a mano.
2. **Server Components por defecto.** `"use client"` solo cuando haya interactividad real (estado, efectos, eventos del navegador).
3. **Sin queries Supabase en componentes.** El acceso a datos pasa por `actions.ts` (o repositories) del dominio correspondiente.
4. **Toda tabla necesita RLS habilitado + policies.** Sin policies no hay acceso. Revisar siempre que existan antes de dar una tabla por funcionando.
5. **Migraciones inmutables.** Nunca editar una migración ya aplicada. Cualquier cambio de esquema = `supabase migration new` + `supabase db diff`.
6. **TypeScript estricto.** Sin `any`, sin `throw` de strings. Errores tipados (clase `Error` o `Result`), manejados en la capa que corresponda.
7. **Un dominio = una carpeta en `/features`.** Si algo no tiene dominio claro, preguntar antes de inventar una ubicación.
8. **Realtime:** toda tabla suscrita a realtime debe estar en la publicación `supabase_realtime` y, si se consumen eventos `DELETE`/`UPDATE`, requiere `REPLICA IDENTITY FULL`.

---

## 6. Flujo SDD (Schema/Spec-Driven Development)

```
1. Spec       → documento en docs/specs/NN-nombre-feature.md
                (contexto, requisitos, modelo de datos Zod+SQL, criterios de aceptación)
2. Aprobación → el usuario valida la spec antes de escribir código
3. Implemente → en features/<domain>/ siguiendo las reglas duras
4. Migración  → si hay cambio de DB: supabase migration new (nunca editar previas)
5. Memoria     → actualizar MEMORY.md (estado, decisiones, deuda, siguientes pasos)
```

**Nunca saltarse la spec.** Si la feature es trivial (cambio cosmético, fix de una línea), preguntar si corresponde spec o no.

---

## 7. Anti-patrones prohibidos

| Prohibido | Ejemplo real encontrado |
|---|---|
| Interfaces de DB a mano fuera del schema | `Message` duplicada en `messagesModule.tsx` y `testChannel.tsx` |
| `throw` de strings | `throw "No se pudo obtener la data"` en `services/profile.ts` |
| Escribir columnas que no existen en la tabla | `createMessage` inserta `author` (la tabla solo tiene `content`, `user_id`) |
| Lógica de negocio en `app/` | cualquier query o transformación dentro de páginas |
| RLS sin policies | tabla `messages` habilitada con RLS pero cero policies |
| Editar migraciones aplicadas | — |
| Instalar dependencias sin aprobación | — |
| Comandos que no sean pnpm | — |

---

## 8. Documentación viva

- **`AGENTS.md`** (este) → reglas y convenciones. Estático.
- **`MEMORY.md`** → estado actual, decisiones con fecha, deuda conocida, últimos cambios, siguientes pasos. **Se lee al iniciar y se actualiza al cerrar.**
- **`docs/specs/`** → especificaciones SDD, una por feature, numeradas.
