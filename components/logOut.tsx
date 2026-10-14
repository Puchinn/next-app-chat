"use client";

import { logOut } from "@/features/profiles";

export function LogOutButton() {
  return (
    <div>
      <button
        onClick={logOut}
        className="shadow-md my-2 p-2 border cursor-pointer text-black border-gray-200 rounded-md bg-gray-50"
      >
        Cerrar sesion
      </button>
    </div>
  );
}
