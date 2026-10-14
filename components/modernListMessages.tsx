"use client";

import { useUserProfile } from "@/context/app-context/useUserProfile";
import { DeleteButton } from "@/components/deleteButton";
import type { Profile } from "@/features/profiles";
import type { Message } from "@/features/chat";
import { useEffect } from "react";

interface ListMessagesProps {
  messages: Message[];
  profilesList: Profile[];
  currentUserId: string | undefined;
  onLoadMore: () => void;
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

  return (
    <div className="chat-card">
      {/* Cabecera del Chat */}
      <div className="chat-header">
        <div>
          <h2 className="text-lg font-bold text-slate-100">Sala de Chat</h2>
          <p className="text-xs text-emerald-400 flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            Canal de pruebas activo
          </p>
        </div>
        <span className="text-xs text-slate-400 bg-slate-900 px-3 py-1 rounded-full border border-slate-800">
          Entorno de Desarrollo
        </span>
      </div>

      {/* Cuerpo del Chat / Lista de Mensajes */}
      <div className="flex-1 overflow-y-auto p-6 space-y-6 custom-scrollbar bg-slate-900/50 chat-body">
        {/* Paginación dentro de la card: carga mensajes más antiguos */}
        <div className="flex justify-center">
          <button type="button" onClick={onLoadMore} className="btn text-sm">
            Cargar mas mensajes
          </button>
        </div>

        {messages.map((msg) => {
          // `currentUserId` llega del server component: no depende del
          // contexto, así el botón de borrar aparece también en mensajes
          // en vivo u optimistas.
          const isMe = !!currentUserId && msg.user_id === currentUserId;
          const authorProfile = profilesList.find((p) => p.id === msg.user_id);
          // Nombre real del autor, sin "null" ni "undefined": perfil del
          // autor, luego el propio perfil del contexto y por último "Anon".
          const authorName =
            authorProfile?.full_name ||
            authorProfile?.username ||
            (isMe ? selfProfile.full_name || selfProfile.username : undefined) ||
            "Anon";
          // Nunca `src=""`: sin avatar usable se genera uno con el nombre.
          const avatarUrl =
            authorProfile?.avatar_url ||
            (isMe ? selfProfile.avatar_url : undefined) ||
            `https://ui-avatars.com/api/?name=${encodeURIComponent(authorName)}`;

          return (
            <div
              key={msg.id}
              className={`flex items-start gap-3 max-w-[80%] group ${
                isMe ? "ml-auto flex-row-reverse" : "mr-auto"
              }`}
            >
              {/* Avatar Redondo */}
              <img
                src={avatarUrl}
                alt={`${authorName}'s avatar`}
                className="w-10 h-10 rounded-full object-cover border-2 border-slate-800 shrink-0"
              />

              {/* Contenedor de Información + Burbuja */}
              <div
                className={`flex flex-col ${isMe ? "items-end" : "items-start"}`}
              >
                {/* Nombre del autor */}
                <span className="text-xs font-medium text-slate-400 mb-1 px-1">
                  {isMe ? "Tú" : authorName}
                </span>

                {/* Fila de la burbuja + botón de borrar */}
                <div
                  className={`flex items-center gap-2 ${isMe ? "flex-row-reverse" : "flex-row"}`}
                >
                  {/* Burbuja del mensaje */}
                  <div
                    className={
                      isMe ? "message-bubble-me" : "message-bubble-other"
                    }
                  >
                    {msg.content ?? ""}
                  </div>

                  {/* Botón Borrar: Oculto por defecto, aparece al hacer hover sobre el mensaje */}
                  {isMe && (
                    <div className="flex items-center justify-center">
                      <DeleteButton id={msg.id} />
                    </div>
                  )}
                </div>
              </div>
            </div>
          );
        })}

        <div id="scrollto" className=""></div>

        {messages.length === 0 && (
          <div className="flex flex-col items-center justify-center h-full text-slate-500 space-y-2">
            <p className="text-sm">No hay mensajes en este chat.</p>
            <p className="text-xs text-slate-600">
              ¡Sé el primero en enviar uno!
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
