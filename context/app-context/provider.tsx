"use client";

import { PropsWithChildren, useEffect } from "react";
import { contextApp } from "./context";
import { useRouter } from "next/navigation";
import type { Profile } from "@/services/profile";
import { useState } from "react";
import { getProfileInfo } from "@/services/profile";

interface ProviderProps extends PropsWithChildren {
  isAuth: boolean;
}

export default function Provider({ children, isAuth }: ProviderProps) {
  const [userProfile, setUserProfile] = useState<Profile | null>(null);

  const router = useRouter();

  useEffect(() => {
    if (isAuth) {
      return router.replace("/login");
    }

    const updateProfileInfo = async () => {
      console.log("ejecutando funcion...");
      const data = await getProfileInfo();
      setUserProfile(data);
    };

    updateProfileInfo();
  }, []);

  return (
    <contextApp.Provider value={userProfile}>{children}</contextApp.Provider>
  );
}
