"use server";

import { createClient } from "@/lib/supabase/server";

export const testing = async (): Promise<string> => {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(user?.id || "");
    }, 1000);
  });
};
