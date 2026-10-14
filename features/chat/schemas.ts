import { z } from "zod";
import { messageAuthorSchema } from "@/features/profiles";

// Mensaje completo de la tabla `messages`.
export const messageSchema = z.object({
  id: z.string(),
  created_at: z.string(),
  content: z.string().nullish(),
  user_id: z.string().nullish(),
});

// Lo único que un cliente puede escribir: nunca id, created_at ni user_id.
export const messageInsertSchema = z.object({
  content: z.string().min(1).max(4000),
});

// Mensaje junto con el perfil del autor (o null si no hay autor visible).
export const messageWithAuthorSchema = z
  .object({
    author: messageAuthorSchema.nullish(),
  })
  .merge(messageSchema);
