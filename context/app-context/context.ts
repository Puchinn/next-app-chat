import { createContext } from "react";
import type { Profile } from "@/services/profile";

const contextApp = createContext<Profile | null>(null);

export { contextApp };
