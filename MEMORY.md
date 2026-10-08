# MEMORY.md

> **Diario del proyecto.** Se lee al iniciar cada tarea y se actualiza al cerrar cada sesión con cambios relevantes.
> Reglas y convenciones → ver `AGENTS.md`.

---

## Estado actual

**Fecha de actualización:** 2026-10-07
**Fase:** F0 completada (documentación base).

- ✅ `AGENTS.md` y `MEMORY.md` creados.
- ✅ Supabase CLI integrado en el proyecto (`supabase/` con `config.toml` + 1 migración de estado actual).
- ⚠️ Código a medio migrar: existe `features/users/` pero el resto vive en `services/` y `components/`.
- ❌ Chat desactivado en `app/page.tsx` (componente `MessagesModule` comentado).
- ❌ Zod no instalado todavía.
- ❌ Varios bugs de desconexión listados en "Deuda y bugs" (bloquean el funcionamiento real).

---

## Decisiones

| Fecha | Decisión |
|---|---|
| 2026-10-07 | Documentación del proyecto en **español**. |
| 2026-10-07 | Unificar los dominios de usuario (`users` + `profiles` inexistente) en una sola tabla **`profiles`** (convención estándar de Supabase). `features/users/` se adaptará hacia `features/profiles/`. |
| 2026-10-07 | Las specs SDD viven en **`docs/specs/`**, numeradas (`NN-nombre-feature.md`). |
| 2026-10-07 | Flujo de trabajo: siempre plan resumido (archivos a modificar/crear/eliminar) + aprobación antes de escribir código o instalar librerías. Siempre `pnpm`. |

---

## Deuda y bugs (inventario)

- [ ] **Tabla `profiles` inexistente** — `services/profile.ts` la consulta, pero solo existe `users` en las migraciones. Además falta el bucket `profiles_avatars` (usado en `app/profile/helps.ts`).
- [ ] **Dos dominios de usuario en conflicto** — `features/users/actions.ts` usa `users`; `services/profile.ts` usa `profiles`. Decisión: unificar en `profiles`.
- [ ] **Insert roto en mensajes** — `createMessage` (`services/messages.ts`) inserta la columna `author`, que no existe en `messages` (solo `content` y `user_id`). Los inserts fallan.
- [ ] **RLS de `messages` sin policies** — RLS habilitado pero cero policies → acceso bloqueado para todos.
- [ ] **Realtime incompleto** — la migración hace `ALTER PUBLICATION supabase_realtime ADD TABLE messages`, pero falta `REPLICA IDENTITY FULL` (los payloads de `DELETE`/`UPDATE` llegarían incompletos).
- [ ] **Chat comentado** — `MessagesModule` está deshabilitado en `app/page.tsx`.
- [ ] **Tipos duplicados** — la interfaz `Message` está declarada a mano en `components/messagesModule.tsx` y `components/testChannel.tsx`.
- [ ] **`throw` de strings** — `services/profile.ts` lanza strings en vez de `Error`.
- [ ] **Zod no instalado.**
- [ ] **`services/` + `components/` sin migrar a `features/`.**
- [ ] **Trigger `handle_new_user`** inserta solo `id` y `email` en `users`; al unificar a `profiles` hay que revisarlo.

---

## Últimos cambios

- **2026-10-07 · F0** — Creación de `AGENTS.md` (reglas, arquitectura de dominios, flujo SDD, anti-patrones, comportamiento obligatorio del agente) y `MEMORY.md` (este documento), con el diagnóstico completo de desconexiones del refactor en curso.

---

## Siguientes pasos

**F1 — Reconexión + cimientos:**
1. Instalar `zod` (previa aprobación).
2. Migración de reconexión Supabase: unificar tabla de usuario en `profiles` + bucket `profiles_avatars` + policies de RLS para `messages` + `REPLICA IDENTITY FULL` + trigger ajustado.
3. Corregir `createMessage` (columna `author` → `user_id`).
4. Definir estructura base de `features/` (mover `services/profile.ts` y `services/messages.ts` a sus dominios).

**F2 —** Migrar `services/` + `components/` → `features/`.
**F3 —** Restaurar chat + verificar realtime end-to-end.
**F4 —** Specs formales en `docs/specs/` para features nuevas.
