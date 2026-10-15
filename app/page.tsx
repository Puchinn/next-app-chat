import { AppShell } from "@/components/appShell";
import { MessagesModule } from "@/components/messagesModule";
import { createClient } from "@/lib/supabase/server";

export default async function Page() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <AppShell activeItem="chat">
      {/* Única secuencia de entrada de la app: fade + slide sutil al montar. */}
      <div className="flex h-full min-h-0 animate-room-enter flex-col motion-reduce:animate-none">
        <header className="sticky top-0 z-20 border-b border-borde bg-papel shadow-sm">
          <div className="mx-auto flex w-full max-w-4xl items-center justify-between gap-3 px-4 py-3">
            <h1 className="font-display text-lg text-tinta">Sala de Chat</h1>
            <p className="flex items-center gap-2 text-xs text-tinta-suave">
              <span
                aria-hidden="true"
                className="h-2 w-2 animate-pulse rounded-full bg-senal motion-reduce:animate-none"
              />
              En vivo
            </p>
          </div>
        </header>

        <MessagesModule userId={user?.id} />
      </div>
    </AppShell>
  );
}
