"use client";

import { LogOut } from "lucide-react";
import { logOut } from "@/features/profiles";

interface LogOutButtonProps {
  /** "rail" = texto + icono (carril lateral); "icon" = solo icono (barra móvil). */
  variant?: "rail" | "icon";
}

export function LogOutButton({ variant = "rail" }: LogOutButtonProps) {
  if (variant === "icon") {
    return (
      <button
        type="button"
        onClick={logOut}
        aria-label="Cerrar sesión"
        className="rounded-lg p-2 text-papel/70 transition-colors hover:bg-papel-alto/5 hover:text-papel"
      >
        <LogOut className="h-5 w-5" aria-hidden="true" />
      </button>
    );
  }

  return (
    <button
      type="button"
      onClick={logOut}
      className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm text-papel/70 transition-colors hover:bg-papel-alto/5 hover:text-papel"
    >
      <LogOut className="h-4 w-4" aria-hidden="true" />
      Cerrar sesión
    </button>
  );
}
