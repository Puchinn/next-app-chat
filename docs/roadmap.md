# Roadmap

> **Plan de trabajo vivo** de ChatApp. El *qué* y el *por qué* de cada tarea.
> El *diario* de sesiones (qué se hizo y cuándo) vive en `MEMORY.md`; este documento
> es el plan. Actualizado: 2026-10-16.

---

## Ciclo de trabajo (mentor/orquestador + usuario)

1. **Contexto** — el estado actual y el problema, explicados antes de decidir.
2. **Propuesta** — alcance (archivos dentro/fuera), criterios de aceptación,
   riesgos y plan de archivos. Aprobación del usuario antes de tocar nada.
3. **Ejecución** — el usuario escribe el código (salvo acuerdo de delegación).
4. **Verificación** — DoD (`pnpm lint`, `pnpm exec tsc --noEmit`, `pnpm build`)
   + smoke si hay UI + lectura del diff por el orquestador. Sin evidencia, no hay ✅.
5. **Enseñanza** — recorrido de cierre: qué cambió, por qué, y cómo depurar si
   se rompe ("si falla X, mira Y").
6. **Cierre** — `MEMORY.md` y este roadmap actualizados.

---

## Backlog

| ID     | Tarea                                                        | Tipo      | Estado    | Sesión |
| ------ | ------------------------------------------------------------ | --------- | --------- | ------ |
| F4.2   | `next/image` + `remotePatterns` para avatares                | Higiene    | **verificada** | 1   |
| F4.3   | Fix: avatar cacheado al reemplazarlo con el mismo formato    | Bugfix     | **verificada** | 1   |
| F4.4   | Fix: mensajes realtime desordenados rompen la agrupación      | Bugfix     | **verificada** | 2   |
| F4.5   | Deuda: avatares huérfanos si falla el `remove` best-effort    | Deuda      | pendiente | 2      |
| F4.6   | UI: el chat solo muestra HH:MM → mensajes de días distintos parecen desordenados | Mejora UI | pendiente | 2      |
| F4.1   | Migrar `components/` legacy a `features/chat`                | Refactor   | pendiente | —      |
| F5.1   | Stack de testing + primeros tests de `features/chat`          | Infra      | pendiente | —      |
| F3.2   | Chat con 2 usuarios en paralelo + UPDATE sin UI              | Verificación | pendiente (el smoke de F4.4 lo cubre en parte) | —   |
| F6.1   | Registro (`signUp` + verificación de email) — spec SDD        | Feature    | pendiente | —      |
| F6.2   | Tema oscuro (toggle sobre los tokens actuales)                | Feature UI | pendiente | —      |
| F0.5.a | Encargo real de migración de `db-supabase` (`migration new` + `db reset`) | Verificación | pendiente | — |
| F0.5.b | Causa raíz del fallo de modelo del `spec-writer`             | Deuda      | pendiente | —      |
| P8     | Payload `DELETE` de realtime truncado: aceptar o re-forzar    | Decisión   | pendiente | —      |
| P9     | Empujar `main` a `origin` (decisión pendiente del usuario)    | Decisión   | pendiente | —      |

**Orden acordado:** sanear antes de construir (higiene → refactor → tests →
verificación runtime) y después features.

---

## Detalle por tarea

### F4.2 — `next/image` + `remotePatterns` (sesión 1)

**Problema.** Los avatares se renderizan con `<img>` cruda (`modernListMessages.tsx`
y `AvatarUpload.tsx`). Next sirve más rápido con `<Image>`: `srcset` con varios
tamaños, formato moderno y sin descargar 500px para mostrar 40px. Además
`pnpm lint` avisa (`no-img-element`, 2 warnings).

**La trampa (lo que hace esta tarea instructiva).** `next/image` solo sirve
imágenes de hosts declarados en `images.remotePatterns`; si falta el host,
**falla en runtime con un 400** (no en build, no en lint). El avatar vive en
Supabase Storage, host externo. Segundo asterisco: la preview de subida usa un
`blob:` de `objectURL`, que `next/image` no optimiza.

**Alcance (3 archivos):**
1. `next.config.ts` — añadir `images.remotePatterns`. **Entorno actual: solo
   local** (`127.0.0.1:54321`). *Deuda consciente:* al desplegar a cloud habrá
   que añadir el host `*.supabase.co` (anotado aquí y en F6.1/F3.2 cuando toque
   runtime en la nube).
2. `components/modernListMessages.tsx` — el `<img>` del avatar del mensaje →
   `<Image>` (40×40, mismo `alt` y clases).
3. `features/profiles/components/AvatarUpload.tsx` — el `<img>` del avatar →
   `<Image>`, con decisión explícita para la preview `blob:` (`unoptimized` o
   `<img>` justificado). **Gotcha:** ya hay `import { Image }` de *lucide-react*
   (el icono) en el mismo archivo: hay que renombrarlo (p. ej. `ImageIcon`).

**Fuera de alcance:** el fallback de iniciales (es un `<span>`, no cambia),
cualquier otra `<img>`, y la configuración de cloud (no existe aún).

**Criterios de aceptación:**
- CA-1 · `pnpm lint` sin warnings `no-img-element`. ✅ Los 2 warnings se
  resolvieron con el fix de `alt` (F2); solo queda `_headers` sin usar en
  `lib/supabase/server.ts`, ajeno a esta tarea.
- CA-2 · `pnpm exec tsc --noEmit` y `pnpm build` en verde. ✅
- CA-3 · Smoke dev: avatar visible en chat y perfil; preview de subida funciona. ✅
- CA-4 · Smoke prod (`pnpm start`): los avatares cargan **sin error 400** de
  imagen (valida `remotePatterns` de verdad; en dev puede enmascararse). ✅
- CA-5 · Fallback de iniciales intacto (sin avatar → `<span>`, nunca `src=""`). ✅

**Cerrada 2026-10-15.** Nota del fix real: `dangerouslyAllowLocalIP` fue
necesario además de `remotePatterns` (lo descubrió el usuario en el smoke).

**Qué enseña:** `remotePatterns` y su fallo en runtime, `Image` vs `img`,
`srcset`/`sizes`/`fill`, y el caso de los `blob:`.

---

### F4.3 — Avatar cacheado al reemplazarlo con el mismo formato (bug de sesión 1)

**Síntoma.** Reemplazar un avatar por otro del **mismo formato** (p. ej. `.png`
por otro `.png`) no cambia la imagen visible: la vieja persiste (incluso tras
recargar). Cambiando de formato sí se actualiza.

**Causa raíz (evidencia en mano).** Tres capas de caché coinciden en la misma
URL:
1. La celda de Storage es estable (`<uid>/avatar.<ext>`, decisión spec 02): al
   mantener el formato, **la URL pública es idéntica**.
2. El upload usa `cacheControl: "3600"` → el Storage responde
   `cache-control: max-age=3600` (verificado con `curl -sI`): el navegador
   cachea esa URL durante 1 hora.
3. Con `next/image` se añade una tercera capa: el optimizer de Next cachea
   `/_next/image?url=...` por URL también.

*Matiz de diagnóstico:* en `pnpm start` recién arrancado el optimizer está
"frío" y sí se ve la imagen nueva; en dev (con caché ya poblada) no. Un bug de
caché "que aparece y desaparece" casi siempre es eso.

**Alcance (1 archivo):** `features/profiles/actions.ts`.

**Fix implementado (2026-10-15) — distinto al propuesto, y mejor.**
`uploadAvatar` guarda la subida en un path con timestamp
(`<uid>/<ms>-avatar.<ext>`), no con el query `?v=<timestamp>` que se había
propuesto. Ventajas frente al query: rompe la caché **en origen** (la URL
pública es nueva) y deja `avatarPathFromPublicUrl` intacto, así que la "trampa
del query" (query pegado al path al hacer `slice` → `remove`/`deleteAvatar`
fallando) **no aplica** en el fix real.

**Criterios de aceptación:**
- CA-1 · Reemplazar el avatar por otro del mismo formato 3 veces seguidas →
  siempre se ve el último (dev, tras recargar). ✅
- CA-2 · **"Eliminar avatar" sigue funcionando** y el bucket queda vacío. ✅
- CA-3 · El chat muestra el avatar nuevo en una segunda pestaña/usuario. ✅
- CA-4 · `pnpm lint`, `pnpm exec tsc --noEmit` y `pnpm build` en verde. ✅
- CA-5 · Compatibilidad: un avatar guardado **antes** del fix (path sin
  timestamp) se puede eliminar sin error. ✅

**Cerrada 2026-10-15. Deuda asociada → F4.5** (el path con timestamp acumula
archivos `<ts>-avatar.<ext>` si el `remove` best-effort falla).

**Qué enseña:** cache-busting, `Cache-Control`/`max-age`, cachés en cadena
(navegador → optimizer → origen) y por qué un fix de "una línea" puede romper
otra parte del mismo archivo (el helper).

---

### F4.4 — Mensajes realtime desordenados rompen la agrupación (bug de sesión 1)

**Síntoma.** Con dos usuarios hablando en paralelo (escalamiento dentro del
mismo minuto), los mensajes de un mismo autor se agrupan juntos aunque no sean
consecutivos: U1 · U1 · U1 · U2 en vez de U1 · U1 · U2 · U1. Minutos después,
al recargar, el orden se arregla solo.

**Causa raíz (la agrupación NO es la culpable).** `modernListMessages` agrupa
por **autor consecutivo del array**, y eso es correcto. El desorden nace
aguas arriba, en `messagesModule.tsx`:
- La lista base (`getMessagesRange`) llega **ordenada por `created_at`** ✅.
- `events.reduce(applyRealtimeEvent, listMessages)` aplica cada evento
  realtime con `upsertMessage`, que **añade al final** del array
  (`[...list, message]`): el orden de la lista fusionada queda determinado
  por el **orden de llegada** de los eventos, no por el timestamp.
- Si el evento de M4 (U1) llega por realtime **antes** que el de M3 (U2),
  la lista es [M1, M2, M4, M3] y la agrupación ve U1·U1·U1·U2.

**Alcance (1 archivo):** `components/messagesModule.tsx`.
- Ordenar la lista fusionada por `created_at` **al derivarla** (antes de
  `useOptimistic`), y también el upsert optimista.
- **Trampas:**
  1. Comparar **fechas parseadas** (`new Date(x).getTime()`), no strings: el
     `created_at` del servidor llega con microsegundos y offset
     (`...00.123456+00:00`) y el del optimista con `Z`; la comparación
     lexicográfica mezcla formatos.
  2. `sort` **muta** el array: con estado de React usa `toSorted` (ES2023) o
     una copia; mutar el estado directamente vuelve impredecible el render.
  3. El orden debe aplicarse **en cada derivación** (también tras
     "Cargar mensajes anteriores", que rehace la lista base).

**Implementado (2026-10-15, sesión 1).** `mergedMessages` se ordena con
`.toSorted((a, b) => new Date(a.created_at).valueOf() - new Date(b.created_at).valueOf())`
**antes** de entrar en `useOptimistic`, así que el orden se recalcula en cada
derivación (realtime + "Cargar mensajes anteriores" + envío). `toSorted` evita
mutar el estado y `new Date(...).valueOf()` compara instantes, no strings.

**Criterios de aceptación:**
- CA-1 · Escenario real con 2 usuarios (2 pestañas, credenciales distintas):
  U1 envía 2 seguidos → U2 responde → U1 envía otro (todo <1 min) → se ve
  U1·U1·U2·U1 en **ambas** pestañas. ✅
- CA-2 · "Cargar mensajes anteriores" no rompe el orden (los antiguos
  arriba, cronológico global). ✅
- CA-3 · Sin regresión del envío optimista: el mensaje propio aparece al
  final al enviarlo y no cambia de sitio al confirmarse. ✅
- CA-4 · `pnpm lint`, `pnpm exec tsc --noEmit` y `pnpm build` en verde. ✅
  (lint 0 errores / 1 warning ajeno, tsc 0, build 0)

**Cerrada 2026-10-16 (sesión 2). Evidencia del smoke** (`pnpm dev` en :3000 +
`chrome-devtools`, stack local):
1. **Determinista (el caso duro).** U1 (tester, navegador) envía `smoke U1 a` y
   `smoke U1 b` (19:46:34 y 19:46:40). Después se inserta por SQL un mensaje de
   **U2 con `created_at` retrocedido** entre ambos (19:46:36.5) → el evento
   realtime llega **el último** pero el mensaje se pinta **entre** los dos de U1
   (`a · U2 · b`) sin recargar. Sin el fix habría quedado `a · b · U2`.
2. **Patrón literal del CA-1.** U1(b,c) → U2(`smoke U2 reply`) → U1(`smoke U1 d`)
   → se ve U1·U1·U2·U1.
3. Orden **intacto tras recargar**; "Cargar mensajes anteriores" también.
4. Optimista: aparece al final al enviarlo y no se mueve al confirmarse; **no**
   se observó la burbuja doble transitoria (deuda de F3, sigue sin reproducirse).
5. Consola limpia (solo `React DevTools` + `[HMR] connected`).

**Bonus del smoke:** el `DELETE` realtime de un borrado externo por SQL propagó
a la UI (regresión de CA-5/P8 en verde). Datos de prueba eliminados al cerrar
(6 filas `smoke %`).

**Nota del escenario:** no hubo dos navegadores; U1 fue el navegador real y U2
insertó por SQL/Postgres (el mismo camino WAL → realtime → suscripción del
cliente), que es lo que importa para reproducir el desorden de llegada.

**Hallazgo lateral → F4.6:** al inspeccionar el orden apareció que la UI solo
pinta `HH:MM`, así que mensajes de **días distintos** parecen desordenados
(13:47 · 20:04 · 16:36 con el orden correcto). No es el bug de F4.4, pero marea.

**Qué enseña:** por qué un array "casi ordenado" no está ordenado, la
diferencia entre orden de llegada y orden de autoría, y a no creerle al
sospechoso obvio (la agrupación) cuando el fallo está en el dato que consume.

---

### F4.5 — Avatares huérfanos si falla el `remove` best-effort (deuda de sesión 1)

**Problema.** Desde F4.3 el path de subida lleva timestamp
(`<uid>/<ms>-avatar.<ext>`). `uploadAvatar` intenta borrar el archivo anterior
como best-effort: si ese `remove` falla (red, permisos), el archivo viejo se
queda en el bucket **sin referencia** en `profiles.avatar_url` — invisible para
la app y sin forma de limpiarlo desde la UI.

**Alcance a decidir:** (a) aceptar la deuda y limpiar puntualmente, o (b) hacer
`remove` estricto (fallar la subida si no se puede borrar el previo), o (c) un
barrido que liste el prefijo `<uid>/` del bucket y borre todo lo que no sea la
URL actual. Probablemente entra cuando haya `db-supabase`/Storage en la nube.

**Criterio de aceptación:** en el bucket solo queda el avatar vigente tras
subir + reemplazar varias veces con un `remove` simulado como fallido.

---

### F4.6 — El chat solo muestra `HH:MM` (hallazgo de la sesión 2)

**Síntoma.** Con mensajes de **días distintos** la lista parece desordenada:
13:47 · 20:04 · 16:36 está en orden cronológico correcto (14, 15 y 16 de
octubre), pero como solo se pinta la hora, se lee como un desorden.

**Alcance a decidir:** separador de fecha por día ("Hoy", "Ayer", fecha corta)
y/o pintar la fecha completa en mensajes de días anteriores. Toca
`components/modernListMessages.tsx` (la hora vive en el encabezado del grupo) y
el formateo (hoy se hace en el componente).

**Criterio de aceptación:** dos días distintos en la lista se distinguen sin
contar hacia atrás; el formato sigue en `es` y sin ruido visual.

---

### F0.5.a — Encargo real de migración de `db-supabase`

**Por qué.** El único smoke importante que falta de la config multiagente: el
MCP de `db-supabase` se probó en inspección, pero **nunca** un ciclo completo
`supabase migration new` + `db reset` + `gen:types`. Es la deuda que más riesgo
tiene si se descubre tarde (el agente que toca la DB es el que aplica reglas
duras de RLS/realtime).

**Alcance:** un cambio de esquema real y pequeño (p. ej. un índice o una policy
que falte) que sirva de encargo de prueba. No inventar tablas.

**Criterio de aceptación:** la migración se aplica con `supabase db reset` sin
errores, `gen:types` no deja diff inesperado y el `reviewer` la aprueba.

---

### F0.5.b — Causa raíz del fallo de modelo del `spec-writer`

**Problema.** Heredar el modelo global (o usar un modelo free explícito) falla
3/3 con `OpenCode's free tier can only be used from within OpenCode`. Hoy se
esquiva fijando el modelo local en el frontmatter; la causa no está
diagnosticada.

**Alcance:** reproducir con un encargo mínimo, revisar la config de proveedores
en `opencode.json` y decidir si es un problema de tier/entitlement o de
resolución de modelo.

**Criterio de aceptación:** el `spec-writer` corre con el modelo que se decida,
sin workaround, o la limitación queda documentada con evidencia.

---

### P9 — Empujar `main` a `origin`

**Decisión pendiente del usuario** (2026-10-15: mantener solo local). Cuando se
decida empujar, es un `git push` de `main`, que va **muy por delante** de
`origin/main` (varias docenas de commits, sin número fijo aquí para no quedar
stale). Sin implicación de código.

---

*(Las tareas F4.1 en adelante se detallan aquí al abrir cada sesión.)*
