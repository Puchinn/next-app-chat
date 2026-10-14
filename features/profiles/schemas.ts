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
