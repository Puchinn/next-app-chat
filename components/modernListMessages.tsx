"use client";

import { useUserProfile } from "@/context/app-context/useUserProfile";
import { DeleteButton } from "@/components/deleteButton";
import type { Profile } from "@/features/profiles";
import type { Message } from "@/features/chat";
import { useEffect } from "react";
import Image from "next/image";

interface ListMessagesProps {
  messages: Message[];
  profilesList: Profile[];
  currentUserId: string | undefined;
  onLoadMore: () => void;
}

// Mensajes consecutivos del mismo autor: avatar y nombre solo en el primero,
// burbujas pegadas dentro del grupo y hora en el último mensaje.
interface MessageGroup {
  key: string;
  isMe: boolean;
  authorName: string;
  avatarUrl: string | undefined;
  messages: Message[];
}

// La hora se muestra solo en mensajes, así que el formateo va en mono,
// tamaño pequeño. Una sola instancia a nivel de módulo.
const timeFormatter = new Intl.DateTimeFormat("es", {
  hour: "2-digit",
  minute: "2-digit",
});

// Iniciales (hasta 2 letras) para el avatar generado con CSS cuando no hay
// `avatar_url` usable. Nunca se apunta a un servicio externo.
function getInitials(name: string): string {
  return (
    name
      .trim()
      .split(/\s+/)
      .slice(0, 2)
      .map((word) => word.charAt(0))
      .join("")
      .toUpperCase() || "?"
  );
}

export default function ChatWindow({
  messages,
  profilesList,
  currentUserId,
  onLoadMore,
}: ListMessagesProps) {
  const selfProfile = useUserProfile();

  useEffect(() => {
    const refer = window.document.querySelector("#scrollto");
    refer?.scrollIntoView();
  }, [messages]);

  // Derivación solo presentacional: agrupar mensajes consecutivos por autor.
  // `currentUserId` llega del server component, así que no depende del
  // contexto y el botón de borrar aparece también en mensajes en vivo u
  // optimistas.
  const groups: MessageGroup[] = [];
  for (const msg of messages) {
    const isMe = !!currentUserId && msg.user_id === currentUserId;
    const authorProfile = profilesList.find((p) => p.id === msg.user_id);
    // Nombre real del autor, sin "null" ni "undefined": perfil del autor,
    // luego el propio perfil del contexto y por último "Anónimo".
    const authorName =
      authorProfile?.full_name ||
      authorProfile?.username ||
      (isMe ? selfProfile.full_name || selfProfile.username : undefined) ||
      "Anónimo";
    // Nunca `src=""`: sin avatar usable se renderizan iniciales.
    const avatarUrl =
      authorProfile?.avatar_url ||
      (isMe ? selfProfile.avatar_url : undefined) ||
      undefined;

    const lastGroup = groups[groups.length - 1];
    if (lastGroup && lastGroup.key === (msg.user_id ?? "")) {
      lastGroup.messages.push(msg);
    } else {
      groups.push({
        key: msg.user_id ?? "",
        isMe,
        authorName,
        avatarUrl,
        messages: [msg],
      });
    }
  }

  return (
    <div className="mx-auto flex min-h-full w-full max-w-4xl flex-col px-4 py-4">
      {/* Paginación: carga mensajes más antiguos (botón fantasma, arriba). */}
      <div className="mb-4 flex justify-center">
        <button
          type="button"
          onClick={onLoadMore}
          className="rounded-lg px-3 py-1.5 text-sm text-tinta-suave transition-colors hover:bg-papel-alto hover:text-tinta"
        >
          Cargar mensajes anteriores
        </button>
      </div>

      <div className="flex flex-1 flex-col space-y-6">
        {groups.map((group) => {
          const firstMessage = group.messages[0];
          const lastMessage = group.messages[group.messages.length - 1];

          return (
            <div
              key={firstMessage.id}
              className={`flex items-start gap-3 ${
                group.isMe ? "flex-row-reverse" : ""
              }`}
            >
              {/* Avatar: solo en el primero del grupo; sin URL usable, iniciales. */}
              {group.avatarUrl ? (
                <Image
                  src={group.avatarUrl}
                  alt={`Avatar de ${group.authorName}`}
                  className="h-10 w-10 shrink-0 rounded-full border border-borde object-cover"
                  width={40}
                  height={40}
                />
              ) : (
                <span
                  aria-hidden="true"
                  className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-full text-xs font-semibold ${
                    group.isMe ? "bg-verde text-white" : "bg-tinta text-papel"
                  }`}
                >
                  {getInitials(group.authorName)}
                </span>
              )}

              {/* Columna del grupo: nombre + burbujas pegadas. El tope de
                  ancho vive aquí (no en la burbuja): referido al grupo, que sí
                  tiene ancho definido, para que los mensajes cortos se
                  ajusten a su contenido en vez de romper línea. */}
              <div
                className={`flex min-w-0 max-w-[min(42rem,85%)] flex-col ${
                  group.isMe ? "items-end" : "items-start"
                }`}
              >
                <span className="mb-1 px-1 text-xs font-medium text-tinta-suave">
                  {group.isMe ? "Tú" : group.authorName}
                </span>

                {group.messages.map((msg, index) => (
                  <div
                    key={msg.id}
                    className={`group flex items-center gap-2 ${
                      index > 0 ? "mt-1" : ""
                    } ${group.isMe ? "flex-row-reverse" : ""}`}
                  >
                    {/* Burbuja: propias verde sólido; ajenas papel-alto con borde. */}
                    <div
                      className={`break-words whitespace-pre-wrap border px-4 py-2.5 text-sm leading-relaxed ${
                        group.isMe
                          ? "rounded-2xl rounded-tr-none border-verde bg-verde text-white"
                          : "rounded-2xl rounded-tl-none border-borde bg-papel-alto text-tinta"
                      }`}
                    >
                      {msg.content ?? ""}
                    </div>

                    {/* Botón borrar: oculto por defecto, aparece al hover del grupo. */}
                    {group.isMe && <DeleteButton id={msg.id} />}
                  </div>
                ))}

                {/* Hora del grupo: debajo de las burbujas, alineada al borde
                    del hablante (evita que quede flotando hacia el centro en
                    los mensajes propios, que van en flex-row-reverse). */}
                <time
                  dateTime={lastMessage.created_at}
                  className="mt-1 px-1 font-mono text-xs text-tinta-suave"
                >
                  {timeFormatter.format(new Date(lastMessage.created_at))}
                </time>
              </div>
            </div>
          );
        })}
      </div>

      <div id="scrollto"></div>

      {messages.length === 0 && (
        <div className="flex flex-1 flex-col items-center justify-center space-y-2 pb-8">
          <p className="text-base font-medium text-tinta">
            Todavía no hay mensajes
          </p>
          <p className="text-sm text-tinta-suave">
            Escribe el primero y arranca la conversación.
          </p>
        </div>
      )}
    </div>
  );
}
