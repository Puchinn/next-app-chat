"use client";

import { logOut } from "@/services/auth";
import { useEffect } from "react";
import { supabaseClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";

export function LogOutButton() {
  const router = useRouter();

  const onLogOut = async () => {
    await logOut();
    router.replace("/");
  };

  const mostrarUser = async () => {
    const { data, error } = await supabaseClient.auth.getSession();
  };

  useEffect(() => {
    mostrarUser();
  }, []);

  return (
    <div>
      <button
        onClick={onLogOut}
        className="shadow-md my-2 p-2 border cursor-pointer border-gray-200 rounded-md bg-gray-50"
      >
        Cerrar sesion
      </button>
    </div>
  );
}
