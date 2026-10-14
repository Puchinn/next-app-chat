"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { profileUpdateSchema } from "./schemas";
import type { ProfileUpdate } from "./types";

export class ProfilesError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ProfilesError";
  }
}

// Perfil del usuario logueado.
export async function getProfile() {
  const supabase = await createClient();

  const { data, error: userError } = await supabase.auth.getUser();
  if (userError || !data?.user) {
    throw new ProfilesError("No hay usuario logueado.");
  }
  const user = data.user;

  const { data: profile, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();
  if (error || !profile) {
    throw new ProfilesError(`Error al obtener el perfil: ${error?.message ?? "sin datos"}`);
  }

  return profile;
}

// Lista de todos los perfiles.
export async function listProfiles() {
  const supabase = await createClient();

  const { data, error } = await supabase.from("profiles").select("*");
  if (error || !data) {
    throw new ProfilesError(`Error al listar perfiles: ${error?.message ?? "sin datos"}`);
  }

  return data;
}

// Actualiza campos del propio perfil. Siempre filtra por el id del usuario logueado.
export async function updateProfile(input: ProfileUpdate) {
  const validated = profileUpdateSchema.safeParse(input);
  if (!validated.success) {
    throw new ProfilesError("Input inválido para actualizar el perfil.");
  }
  const supabase = await createClient();

  const { data, error: userError } = await supabase.auth.getUser();
  if (userError || !data?.user) {
    throw new ProfilesError("No hay usuario logueado.");
  }
  const user = data.user;

  const { data: profile, error } = await supabase
    .from("profiles")
    .update(validated.data)
    .eq("id", user.id)
    .select("*")
    .single();
  if (error || !profile) {
    throw new ProfilesError(`Error al actualizar el perfil: ${error?.message ?? "sin datos"}`);
  }

  return profile;
}

// Cierre de sesión y redirección al login.
export async function logOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}
