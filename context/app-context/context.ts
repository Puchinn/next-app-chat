import { createContext } from "react";
import type { Profile } from "@/features/profiles";

const contextApp = createContext<Profile | null>(null);

export { contextApp };
