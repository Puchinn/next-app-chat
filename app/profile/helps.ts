"use server";

import { createClient } from "@/lib/supabase/server";

const getPublicUrl = async (path: string) => {
  const supabase = await createClient();
  const { data } = supabase.storage.from("profiles_avatars").getPublicUrl(path);

  return data.publicUrl;
};

const uploadFile = async (file: File) => {
  const supabase = await createClient();
  const storage = supabase.storage.from("profiles_avatars");
  const { data, error } = await storage.upload(file.name, file, {
    upsert: true,
  });

  if (error) {
    console.log(error);
    throw "Error al subir la imagen";
  }

  const publicUrl = storage.getPublicUrl(data.path);

  return publicUrl.data.publicUrl;
};

export { uploadFile, getPublicUrl };
