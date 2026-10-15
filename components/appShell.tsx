import Link from "next/link";
import { MessageCircle, User } from "lucide-react";
import { LogOutButton } from "./logOut";

export type AppShellItem = "chat" | "profile";

interface AppShellProps {
  children: React.ReactNode;
  activeItem: AppShellItem;
}

const NAV_ITEMS = [
  { key: "chat" satisfies AppShellItem, href: "/", label: "Chat", Icon: MessageCircle },
  {
    key: "profile" satisfies AppShellItem,
    href: "/profile",
    label: "Perfil",
    Icon: User,
  },
] as const;

/*
 * Shell de altura completa tipo app de chat (presentacional, sin "use client":
 * lo consumen server components). Desktop: carril lateral fijo de tinta.
 * Móvil: barra superior compacta con los mismos destinos como iconos.
 */
export function AppShell({ children, activeItem }: AppShellProps) {
  return (
    <div className="flex h-dvh flex-col overflow-hidden md:flex-row">
      {/* Carril lateral (desktop ≥768px) */}
      <aside className="rail-tinta hidden w-60 shrink-0 flex-col bg-tinta text-papel md:flex">
        <div className="px-4 py-5">
          <span className="font-display text-xl text-papel">APPCITA</span>
        </div>

        <nav
          aria-label="Navegación principal"
          className="flex-1 space-y-1 px-2"
        >
          {NAV_ITEMS.map(({ key, href, label, Icon }) => {
            const isActive = key === activeItem;
            return (
              <Link
                key={key}
                href={href}
                aria-current={isActive ? "page" : undefined}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${
                  isActive
                    ? "bg-papel-alto/10 font-medium text-papel"
                    : "text-papel/70 hover:bg-papel-alto/5 hover:text-papel"
                }`}
              >
                <Icon className="h-4 w-4" aria-hidden="true" />
                {label}
              </Link>
            );
          })}
        </nav>

        <div className="border-t border-papel/10 p-2">
          <LogOutButton variant="rail" />
        </div>
      </aside>

      {/* Barra superior (móvil <768px) */}
      <header className="rail-tinta flex items-center gap-1 bg-tinta px-3 py-2 text-papel md:hidden">
        <span className="mr-auto font-display text-lg">APPCITA</span>

        {NAV_ITEMS.map(({ key, href, label, Icon }) => {
          const isActive = key === activeItem;
          return (
            <Link
              key={key}
              href={href}
              aria-label={label}
              aria-current={isActive ? "page" : undefined}
              className={`rounded-lg p-2 transition-colors ${
                isActive
                  ? "bg-papel-alto/10 text-papel"
                  : "text-papel/70 hover:bg-papel-alto/5 hover:text-papel"
              }`}
            >
              <Icon className="h-5 w-5" aria-hidden="true" />
            </Link>
          );
        })}

        <LogOutButton variant="icon" />
      </header>

      <main className="flex min-h-0 flex-1 flex-col">{children}</main>
    </div>
  );
}
