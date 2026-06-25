"use client";

import { useState, useEffect } from "react";
import TestChannel from "./testChannel";
import { CreateMessageServerAction } from "./createMessage.server";
import { useOptimistic, startTransition } from "react";
import { onCreateMessage } from "./help";
import { getAllMesagges } from "@/services/messages";
import ChatList from "./modernListMessages";
import type { Profile } from "@/services/profile";
import { getAllProfiles } from "@/services/profile";

interface Message {
  id: string;
  content: string;
  author?: string;
  user_id: string;
}

interface ListMessagesProps {
  userId: string | undefined;
}

export function MessagesModule({ userId }: ListMessagesProps) {
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [listMessages, setListMessages] = useState<Message[]>([]);
  const [optimisticList, setOptimisticList] =
    useOptimistic<Message[]>(listMessages);

  const onUpdateListMessage = (message: Message) => {
    setListMessages((prev) => [...prev, message]);
  };

  const deleteMessage = (id: string) => {
    setListMessages((prev) => prev.filter((m) => m.id !== id));
  };

  const onSendMessage = (message: string) => {
    startTransition(async () => {
      const newValue: Message = {
        content: message,
        user_id: userId || "random-id",
        author: "loading...",
        id: "id-unico e indispensable xd",
      };

      setOptimisticList((prev) => [...prev, newValue]);
      const instertedMessage = (await onCreateMessage(message)) as Message;
      startTransition(() => {
        setListMessages((prev) => [...prev, instertedMessage]);
      });
    });
  };

  useEffect(() => {
    const syncMessages = async () => {
      const messages = (await getAllMesagges()) as Message[];

      setListMessages(messages);
    };
    syncMessages();

    const getProfiles = async () => {
      const profilesList = await getAllProfiles();
      setProfiles(profilesList);
    };
    getProfiles();
  }, []);

  return (
    <div className="space-y-2">
      <ChatList profilesList={profiles} messages={optimisticList} />

      <CreateMessageServerAction onSendMessage={onSendMessage} />
      <TestChannel
        onDeleteMessage={deleteMessage}
        onUpdateList={onUpdateListMessage}
        userId={userId}
      />
    </div>
  );
}
