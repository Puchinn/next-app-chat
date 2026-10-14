import { z } from "zod";
import {
  messageAuthorSchema,
  profileSchema,
  profileUpdateSchema,
} from "./schemas";

export type Profile = z.infer<typeof profileSchema>;
export type ProfileUpdate = z.infer<typeof profileUpdateSchema>;
export type MessageAuthor = z.infer<typeof messageAuthorSchema>;
