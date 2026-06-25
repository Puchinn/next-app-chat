"use server";

import { createClient } from "@/lib/supabase/server";

const getAllMesagges = async () => {
  const supabase = await createClient();
  const { data, error } = await supabase.from("messages").select("*");

  if (error) {
    console.log(error);
  }

  return data;
};

const deleteMessage = async (id: string) => {
  const supabase = await createClient();

  const { success, error, status } = await supabase
    .from("messages")
    .delete()
    .eq("id", id);

  return { success, error };
};

const createMessage = async (message: string) => {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data, error } = await supabase
    .from("messages")
    .insert({
      content: message,
      author: user?.email,
    })
    .select()
    .single();

  if (error) {
    console.log(
      "erroro al crear el mensaje en la tabla message:",
      error.message,
    );
  }

  return data;
};

export { getAllMesagges, createMessage, deleteMessage };
