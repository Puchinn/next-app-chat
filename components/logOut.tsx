"use client";

import { logOut } from "@/services/auth";
import { useRouter } from "next/navigation";

export function LogOutButton() {
  const router = useRouter();

  const onLogOut = async () => {
    await logOut();
    router.replace("/");
  };

  return (
    <div>
      <button
        onClick={onLogOut}
        className="shadow-md my-2 p-2 border cursor-pointer text-black border-gray-200 rounded-md bg-gray-50"
      >
        Cerrar sesion
      </button>
    </div>
  );
}
