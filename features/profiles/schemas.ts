import { z } from "zod";

// Perfil completo de la tabla `profiles`.
export const profileSchema = z.object({
  id: z.string(),
  created_at: z.string(),
  email: z.string().nullish(),
  username: z.string().nullish(),
  full_name: z.string().nullish(),
  avatar_url: z.string().nullish(),
});

// Campos escribibles por el usuario: nunca id, email ni created_at.
export const profileUpdateSchema = z.object({
  username: z.string().nullish(),
  full_name: z.string().nullish(),
  avatar_url: z.string().nullish(),
});

// Subconjunto del perfil que se expone al chat.
export const messageAuthorSchema = z.object({
  id: z.string(),
  username: z.string().nullish(),
  avatar_url: z.string().nullish(),
});

// Input de la acción `uploadAvatar`: un `File` del navegador no es modelable
// en Zod (es binario y client-side). Este schema modela el OUTPUT de la acción:
// `{ avatar_url }` (la URL pública devuelta por Supabase Storage).
export const avatarUploadedSchema = z.object({
  avatar_url: z.string().url().nullish(),
});

// Mapeo MIME -> extensión permitida al subir un avatar.
export const AVATAR_MIME_EXT: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
  "image/gif": "gif",
};

// Límite de tamaño de un avatar: 2 MB.
export const AVATAR_MAX_BYTES = 2 * 1024 * 1024; // 2 MB

// Códigos de error de las acciones de avatar. Se devuelven junto a un mensaje
// legible para que sean serializables y visibles en el cliente: Next enmascara
// los `throw` de server actions en producción, así que el resultado viaja
// serializado en vez de lanzarse.
export const AVATAR_ERROR_CODES = [
  "INVALID_TYPE",
  "TOO_LARGE",
  "NOT_AUTHENTICATED",
  "STORAGE_ERROR",
  "PROFILE_ERROR",
] as const;

// Resultado de `uploadAvatar` / `deleteAvatar`: unión discriminada por `ok`,
// donde el caso de error lleva un `code` tipado (AVATAR_ERROR_CODES) y un
// `message` legible que viaja serializado hasta el cliente.
export const avatarResultSchema = z.discriminatedUnion("ok", [
  z.object({ ok: z.literal(true), avatar_url: z.string().url().nullish() }),
  z.object({
    ok: z.literal(false),
    code: z.enum(AVATAR_ERROR_CODES),
    message: z.string(),
  }),
]);
