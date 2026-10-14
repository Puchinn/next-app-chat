import type { z } from "zod";
import { messageInsertSchema, messageSchema, messageWithAuthorSchema } from "./schemas";

// Tipos derivados de los esquemas Zod; sin interfaces a mano.
export type Message = z.infer<typeof messageSchema>;
export type MessageInsert = z.infer<typeof messageInsertSchema>;
export type MessageWithAuthor = z.infer<typeof messageWithAuthorSchema>;

// Evento realtime de la tabla `messages` (INSERT / UPDATE / DELETE).
export type RealtimeEventPayload =
  | { eventType: "INSERT"; new: Message; old: null }
  | { eventType: "UPDATE"; new: Message; old: Message }
  | { eventType: "DELETE"; new: null; old: Message };
