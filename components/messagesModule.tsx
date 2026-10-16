"use client";

import { useState, useEffect } from "react";
import { CreateMessageServerAction } from "./createMessage.server";
import { useOptimistic, startTransition } from "react";
import { onCreateMessage } from "./help";
import { getMessagesRange, useMessagesRealtime } from "@/features/chat";
import type { Message, RealtimeEventPayload } from "@/features/chat";
import ChatList from "./modernListMessages";
import type { Profile } from "@/features/profiles";
import { listProfiles } from "@/features/profiles";

interface ListMessagesProps {
  userId: string | undefined;
}

// Upsert idempotente por `id`: si el mensaje ya existe lo reemplaza; si no,
// lo añade al final (la lista se muestra de más antiguo a más nuevo).
function upsertMessage(list: Message[], message: Message): Message[] {
  const exists = list.some((m) => m.id === message.id);
  if (exists) {
    return list.map((m) => (m.id === message.id ? message : m));
  }
  return [...list, message];
}

// Aplica un evento realtime sobre la lista: INSERT/UPDATE hacen upsert por
// `id` y DELETE filtra por `old.id`. El upsert por `id` resuelve el dedupe
// solo: el mensaje del propio usuario no se duplica aunque vuelva por
// realtime (p. ej. desde otra pestaña o dispositivo).
function applyRealtimeEvent(
  list: Message[],
  event: RealtimeEventPayload,
): Message[] {
  if (event.eventType === "DELETE") {
    return list.filter((m) => m.id !== event.old.id);
  }
  return upsertMessage(list, event.new);
}

export function MessagesModule({ userId }: ListMessagesProps) {
  const [rangeMessages, setRangeMessages] = useState({
    from: 0,
    to: 19,
  });
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [listMessages, setListMessages] = useState<Message[]>([]);
  const { events } = useMessagesRealtime();

  // La lista mostrada se deriva en cada render: base (fetch + inserts del
  // server action) fusionada con los eventos realtime acumulados. Recorrer
  // `events` sobre la base es idempotente por `id`, así que no hace falta
  // un effect que haga setState (y re-ejecutarlo tras refrescar el rango
  // no duplica mensajes).
  const mergedMessages = events
    .reduce(applyRealtimeEvent, listMessages)
    .toSorted(
      (a, b) =>
        new Date(a.created_at).valueOf() - new Date(b.created_at).valueOf(),
    );
  const [optimisticList, setOptimisticList] =
    useOptimistic<Message[]>(mergedMessages);

  const nextRange = () => {
    const newRange = {
      from: 0,
      to: (rangeMessages.to + 1) * 2,
    };
    setRangeMessages(newRange);
  };

  const onSendMessage = (message: string) => {
    startTransition(async () => {
      // Mensaje optimista con id temporal único. Al terminar el transition
      // se muestra la lista real, que ya contiene el mensaje insertado.
      const optimisticMessage: Message = {
        id: `optimistic-${Date.now()}-${Math.random().toString(36).slice(2)}`,
        created_at: new Date().toISOString(),
        content: message,
        user_id: userId ?? null,
      };

      setOptimisticList((prev) => upsertMessage(prev, optimisticMessage));
      try {
        const insertedMessage = (await onCreateMessage(message)) as Message;
        startTransition(() => {
          setListMessages((prev) => upsertMessage(prev, insertedMessage));
        });
      } catch (error) {
        console.error(error);
      }
    });
  };

  useEffect(() => {
    const syncMessages = async () => {
      const messages = (await getMessagesRange(
        rangeMessages.from,
        rangeMessages.to,
      )) as Message[];

      setListMessages(messages.reverse());
    };
    syncMessages();

    const getProfiles = async () => {
      try {
        const profilesList = await listProfiles();
        setProfiles(profilesList);
      } catch (error) {
        console.error(error);
        setProfiles([]);
      }
    };
    getProfiles();
  }, [rangeMessages]);

  // Columna de chat: la lista scrollea por dentro y el composer queda
  // anclado abajo (sticky) dentro de la columna.
  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="custom-scrollbar min-h-0 flex-1 overflow-y-auto">
        <ChatList
          profilesList={profiles}
          messages={optimisticList}
          currentUserId={userId}
          onLoadMore={nextRange}
        />
      </div>

      <div className="sticky bottom-0 z-10 border-t border-borde bg-papel-alto px-4 py-3 shadow-sm">
        <div className="mx-auto w-full max-w-4xl">
          <CreateMessageServerAction onSendMessage={onSendMessage} />
        </div>
      </div>
    </div>
  );
}
