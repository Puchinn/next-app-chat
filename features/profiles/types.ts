import { z } from "zod";
import {
  avatarResultSchema,
  avatarUploadedSchema,
  messageAuthorSchema,
  profileSchema,
  profileUpdateSchema,
} from "./schemas";

export type Profile = z.infer<typeof profileSchema>;
export type ProfileUpdate = z.infer<typeof profileUpdateSchema>;
export type MessageAuthor = z.infer<typeof messageAuthorSchema>;
export type AvatarUploaded = z.infer<typeof avatarUploadedSchema>;
export type AvatarResult = z.infer<typeof avatarResultSchema>;
