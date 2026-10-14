-- F1 — Reconexión con Supabase (docs/specs/01-reconexion-supabase.md §3.3):
-- unifica `users` + `profiles`, RLS completo en `profiles` y `messages`,
-- REPLICA IDENTITY FULL, trigger `handle_new_user` y policies de Storage
-- para el bucket `profiles_avatars`.
--
-- Esta migración NO se aplica desde acá: el usuario la ejecuta con
-- `pnpm dlx supabase db reset` (aprobación explícita pendiente).
-- `20261008015400_estado_actual.sql` es inmutable y no se toca.

-- 1) Nueva tabla `profiles` (unifica `users`; convención estándar de Supabase).
CREATE TABLE public.profiles (
  id         uuid PRIMARY KEY,              -- = auth.users.id (1:1)
  created_at timestamptz NOT NULL DEFAULT now(),
  email      text,
  username   text,                          -- rename de users.user_name
  full_name  text,
  avatar_url text
);

-- 2) Migrar los datos existentes de `users` a `profiles` (user_name → username).
--    `full_name` y `avatar_url` quedan NULL (son columnas nuevas).
INSERT INTO public.profiles (id, created_at, email, username)
SELECT id, created_at, email, user_name
FROM public.users;

-- 3) `messages.user_id` apunta a `profiles.id` (mismo uuid que `auth.users.id`).
--    La FK se declara para documentar la relación (spec §3.3); en un `db reset`
--    las tablas están vacías, así que no puede fallar por datos huérfanos.
ALTER TABLE public.messages
  ADD CONSTRAINT messages_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles (id)
  ON DELETE SET NULL;

-- 4) Borrar la tabla antigua. Siempre DESPUÉS de copiar los datos (paso 2).
--    Sus policies y grants mueren con la tabla.
DROP TABLE public.users;

-- 5) RLS de `profiles` (tabla nueva: RLS venía apagado por defecto).
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5a) Ver el propio perfil (redundante con 5b hoy, la dejan por REQ-3a).
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT TO authenticated
  USING (id = (select auth.uid()));

-- 5b) Ver todos los perfiles (listado público del chat: un solo canal).
CREATE POLICY "profiles_select_public" ON public.profiles
  FOR SELECT TO authenticated, anon
  USING (true);

-- 5c) Actualizar solo el propio perfil (username, full_name, avatar_url).
--     USING + WITH CHECK: si no, el usuario podría reasignar `id`.
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE TO authenticated
  USING (id = (select auth.uid()))
  WITH CHECK (id = (select auth.uid()));

-- 5d) Insertar solo el propio perfil (fallback "el trigger aún no corrió").
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = (select auth.uid()));

-- 6) RLS de `messages`: ya estaba habilitado en la migración previa con CERO
--    policies (todo bloqueado); se reafirma el ENABLE y se agregan las policies.
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 6a) Ver todos los mensajes (chat público de un solo canal).
CREATE POLICY "messages_select_all" ON public.messages
  FOR SELECT TO authenticated, anon
  USING (true);

-- 6b) Insertar solo como el propio usuario autenticado.
CREATE POLICY "messages_insert_own" ON public.messages
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

-- 6c) Actualizar solo el propio mensaje (content; ni timestamp ni id).
CREATE POLICY "messages_update_own" ON public.messages
  FOR UPDATE TO authenticated
  USING (user_id = (select auth.uid()))
  WITH CHECK (user_id = (select auth.uid()));

-- 6d) Borrar solo el propio mensaje. El `deleteMessage` genérico del código
--     actual queda restringido por RLS: sin esta policy el borrado estaba
--     bloqueado para todos; con ella, cada usuario borra lo que escribió.
CREATE POLICY "messages_delete_own" ON public.messages
  FOR DELETE TO authenticated
  USING (user_id = (select auth.uid()));

-- 7) Realtime: `messages` YA está en la publicación `supabase_realtime`
--    (migración previa — no repetir el ALTER PUBLICATION). Sin esto, los
--    eventos DELETE/UPDATE llegarían con `old_record` incompleto o nulo.
ALTER TABLE public.messages REPLICA IDENTITY FULL;

-- 8) Índice para las policies de autor (UPDATE/DELETE por user_id) y para las
--    chequeos de la FK recién creada: hoy messages solo indexa su PK `id`.
CREATE INDEX messages_user_id_idx ON public.messages (user_id);

-- 9) Trigger de alta: ahora inserta en `profiles`, idempotente con
--    ON CONFLICT (el trigger `new_user` sobre auth.users YA existe en la
--    migración previa: no se duplica; solo se reemplaza la función).
--    SECURITY DEFINER es necesario: el trigger corre en el contexto de la
--    inserción sobre `auth.users` y debe escribir en `public.profiles` sin
--    depender de los grants/RLS de ese rol. `search_path` queda fijado y el
--    cuerpo usa nombres completamente calificados (`public.profiles`).
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public'
AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (NEW.id, NEW.email)
  ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
  RETURN NEW;
END;
$$;

-- 10) Grants de la tabla nueva (los de `users` murieron con el DROP). Sin
--     grants, las policies de arriba ni siquiera se evalúan: permission denied.
GRANT SELECT ON TABLE public.profiles TO anon, authenticated, service_role;
GRANT INSERT, UPDATE, DELETE ON TABLE public.profiles TO authenticated, service_role;

-- 11) Storage: policies para el bucket `profiles_avatars` (REQ-7 / P2).
--
--     ATENCIÓN — EL BUCKET NO SE CREA EN ESTA MIGRACIÓN:
--     los buckets son runtime, no schema. Hay que crearlo a mano UNA VEZ en el
--     stack local (Supabase Studio → Storage → New bucket):
--         nombre:  profiles_avatars
--         público: TRUE  (lectura pública para servir la URL del avatar)
--     Las policies de abajo quedan preparadas aunque el bucket todavía no
--     exista: solo filtran `bucket_id = 'profiles_avatars'` y no dependen de él.
--
--     Convención de path: los objetos van en `<auth.uid()>/<archivo>`, y esa
--     carpeta es la que comprueba el RLS (upload/borrar solo del dueño).
CREATE POLICY "profiles_avatars_select_public" ON storage.objects
  FOR SELECT TO authenticated, anon
  USING (bucket_id = 'profiles_avatars');

CREATE POLICY "profiles_avatars_insert_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  );

CREATE POLICY "profiles_avatars_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'profiles_avatars'
    AND (storage.foldername(name))[1] = (select auth.uid())::text
  );
