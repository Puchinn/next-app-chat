import { useUserProfile } from "@/context/app-context/useUserProfile";
import { DeleteButton } from "@/components/deleteButton";
import type { Profile } from "@/services/profile";
import { useEffect } from "react";

interface Message {
  id: string;
  content: string;
  author?: string;
  user_id: string;
}

interface ListMessagesProps {
  messages: Message[];
  profilesList: Profile[];
}

export default function ChatWindow({
  messages,
  profilesList,
}: ListMessagesProps) {
  const { avatar_url, id } = useUserProfile();

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
        {messages.map((msg) => {
          const isMe = msg.user_id === id;
          const userProfile = profilesList.find((p) => p.id == msg.user_id);

          return (
            <div
              key={msg.id}
              className={`flex items-start gap-3 max-w-[80%] group ${
                isMe ? "ml-auto flex-row-reverse" : "mr-auto"
              }`}
            >
              {/* Avatar Redondo */}
              <img
                src={
                  isMe
                    ? avatar_url
                    : userProfile?.avatar_url ||
                      `https://ui-avatars.com/api/?name=${msg.author}`
                }
                alt={`${userProfile?.full_name}'s avatar`}
                className="w-10 h-10 rounded-full object-cover border-2 border-slate-800 shrink-0"
              />

              {/* Contenedor de Información + Burbuja */}
              <div
                className={`flex flex-col ${isMe ? "items-end" : "items-start"}`}
              >
                {/* Nombre del autor */}
                <span className="text-xs font-medium text-slate-400 mb-1 px-1">
                  {isMe ? "Tú" : userProfile?.username}
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
                    {msg.content}
                  </div>

                  {/* Botón Borrar: Oculto por defecto, aparece al hacer hover sobre el mensaje */}
                  {isMe && (
                    <div className="flex items-center justify-center">
                      <DeleteButton id={msg.id} />{" "}
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
