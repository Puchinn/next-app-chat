"use client";

import { supabaseClient } from "@/lib/supabase/client";
import { useEffect } from "react";

interface Message {
  id: string;
  content: string;
  author?: string;
  user_id: string;
}

export default function TestChannel({
  onUpdateList,
  userId,
  onDeleteMessage,
}: {
  onUpdateList: (message: Message) => void;
  userId: string | undefined;
  onDeleteMessage: (id: string) => void;
}) {
  useEffect(() => {
    const channel = supabaseClient
      .channel("messages")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "messages",
        },
        (payload) => {
          const { eventType } = payload;
          const messagePayload = payload.new as Message;
          const deletedMessage = payload.old as Message;
          if (userId && userId === messagePayload.user_id) return;
          if (eventType === "INSERT") {
            onUpdateList(payload.new as Message);
          }
          if (eventType === "DELETE") {
            onDeleteMessage(deletedMessage.id);
          }
        },
      )
      .subscribe();

    return () => {
      supabaseClient.removeChannel(channel);
    };
  }, []);

  return null;
}
