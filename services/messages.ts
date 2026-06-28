"use server";

import { createClient } from "@/lib/supabase/server";

const getAllMesagges = async () => {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("messages")
    .select("*")
    .order("created_at", {
      ascending: false,
    })
    .limit(20);

  if (error) {
    console.log(error);
  }

  return data;
};

const getMessagesRange = async (from: number, to: number) => {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("messages")
    .select("*")
    .order("created_at", {
      ascending: false,
    })
    .range(from, to);

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

export { getAllMesagges, createMessage, deleteMessage, getMessagesRange };
