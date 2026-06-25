"use server";

import { createClient } from "@/lib/supabase/server";

export interface Profile {
  id: string;
  username: string;
  full_name: string;
  avatar_url: string;
  email: string;
}

const getProfileInfo = async () => {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  const userId = user?.id;

  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", userId)
    .single();

  if (error) throw "No se pudo obtener la data";

  const userData = data as Profile;

  return userData;
};

const getAllProfiles = async () => {
  const supabase = await createClient();

  const { data, error } = await supabase.from("profiles").select("*");
  if (error) throw "No se pudo obtener la data";

  return data as Profile[];
};

const updateProfileInfo = async (profileInfo: Partial<Profile>) => {
  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update(profileInfo)
    .eq("id", profileInfo.id);

  if (error) throw "No se pudo actualizar la data";

  return {
    succes: true,
    message: "actualizado correctamente",
  };
};

export { getProfileInfo, updateProfileInfo, getAllProfiles };
