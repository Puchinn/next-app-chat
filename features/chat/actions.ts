"use server";

import { createClient } from "@/lib/supabase/server";
import { ChatError } from "./errors";
import { messageInsertSchema } from "./schemas";
import type { MessageInsert } from "./types";

// Lista los últimos 20 mensajes, del más nuevo al más viejo.
export async function listMessages() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("messages")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(20);
  if (error) throw new ChatError(error.message);
  return data;
}

// Lista un rango de mensajes, del más nuevo al más viejo.
export async function getMessagesRange(from: number, to: number) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("messages")
    .select("*")
    .order("created_at", { ascending: false })
    .range(from, to);
  if (error) throw new ChatError(error.message);
  return data;
}

// Crea un mensaje para el usuario logueado. La validación es con Zod.
export async function createMessage(input: MessageInsert) {
  const parsed = messageInsertSchema.safeParse(input);
  if (!parsed.success) {
    throw new ChatError("Contenido inválido: " + JSON.stringify(parsed.error.issues));
  }
  const supabase = await createClient();
  const { data, error } = await supabase.auth.getUser();
  if (error) throw new ChatError(error.message);
  const user = data?.user;
  if (!user) throw new ChatError("Usuario no logueado");
  const { data: message, error: insertError } = await supabase
    .from("messages")
    .insert({ content: parsed.data.content, user_id: user.id })
    .select("*")
    .single();
  if (insertError) throw new ChatError(insertError.message);
  return message;
}

// Borra un mensaje por id. La restricción de autor la aplica RLS.
export async function deleteMessage(id: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("messages")
    .delete()
    .eq("id", id)
    .select("*");
  if (error) throw new ChatError(error.message);
  return data;
}
