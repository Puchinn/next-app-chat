"use server";

import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { User } from "./types";
import { revalidatePath } from "next/cache";

export async function logOut() {
  const supabase = await createClient();

  await supabase.auth.signOut();

  redirect("/login");
}

export async function getUserInfo() {
  const supabase = await createClient();

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error) throw new Error("Usuario no autenticado.");

  const { data, error: queryError } = await supabase
    .from("users")
    .select("*")
    .eq("id", user?.id)
    .single();

  if (queryError) throw new Error("Usuario no encontrado.");

  return data;
}

export async function updateUserInfo(user: Partial<User>) {
  const supabase = await createClient();

  const {
    data: { user: findedUser },
    error,
  } = await supabase.auth.getUser();

  if (error) throw new Error("Usuario no autenticado.");

  const { data, error: queryError } = await supabase
    .from("users")
    .update(user)
    .eq("id", findedUser?.id)
    .select("*")
    .single();

  if (queryError)
    throw new Error("Ocurrio un error al intentar actualizar el perfil");

  revalidatePath("/");
  return data;
}
