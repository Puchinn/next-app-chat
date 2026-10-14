import { useContext } from "react";
import { contextApp } from "./context";
import type { Profile } from "@/features/profiles";

export function useUserProfile(): Partial<Profile> {
  const data = useContext(contextApp);

  if (!data) {
    return {};
  }

  return data;
}
