import { LogOutButton } from "@/components/logOut";
import { MessagesModule } from "@/components/messagesModule";
import { createClient } from "@/lib/supabase/server";
import Link from "next/link";

interface Message {
  id: string;
  content: string;
  author?: string;
  user_id: string;
}

export default async function Page() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <section className="p-2 space-y-2">
      <nav className="bg-gray-50 p-2 flex items-center w-full gap-3 rounded-md border border-gray-200">
        <div className="flex-1 h-auto">
          <h2>APPCITA</h2>
        </div>
        <LogOutButton />
        <Link
          href={"/profile"}
          className="shadow-md my-2 p-2 rounded-md border border-gray-200 bg-gray-50"
        >
          Ir al perfil.
        </Link>
      </nav>

      <MessagesModule userId={user?.id} />
    </section>
  );
}
