import { createClient } from "@/lib/supabase/server";
import { supabaseClient } from "@/lib/supabase/client";

export const logOut = async () => {
  const { error } = await supabaseClient.auth.signOut();
  console.log(error);
};

export const isAuthenticated = async () => {
  const supabase = await createClient();

  const { data, error } = await supabase.auth.getClaims();

  return data;
};
