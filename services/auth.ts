import { createClient } from "@/lib/supabase/server";

export const logOut = async () => {
  const supabase = await createClient();
  supabase.auth.signOut();
};

export const isAuthenticated = async () => {
  const supabase = await createClient();

  const { data, error } = await supabase.auth.getClaims();

  return data;
};
