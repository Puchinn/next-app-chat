import { NextResponse } from "next/server";
import { createClient } from "./lib/supabase/server";

export async function middleware(req: Request) {
  const supabase = await createClient();
  const { data } = await supabase.auth.getClaims();

  if (!data) {
    return NextResponse.rewrite(new URL("/login", req.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/", "/profile"],
};
