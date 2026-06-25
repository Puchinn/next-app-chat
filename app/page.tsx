import { LogOutButton } from "@/components/logOut";
import { MessagesModule } from "@/components/messagesModule";
import { createClient } from "@/lib/supabase/server";
import Link from "next/link";

export default async function Page() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <section className="p-2 space-y-2">
      <nav className="card flex items-center max-w-7xl mx-auto w-full gap-3 p-3">
        <div className="flex-1 h-auto">
          <h2 className="text-lg font-bold text-slate-100">APPCITA</h2>
        </div>
        <LogOutButton />
        <Link href={"/profile"} className="btn">
          Ir al perfil.
        </Link>
      </nav>

      <MessagesModule userId={user?.id} />
    </section>
  );
}
