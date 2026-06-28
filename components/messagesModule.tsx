"use client";

import { useState, useEffect } from "react";
import TestChannel from "./testChannel";
import { CreateMessageServerAction } from "./createMessage.server";
import { useOptimistic, startTransition } from "react";
import { onCreateMessage } from "./help";
import { getAllMesagges, getMessagesRange } from "@/services/messages";
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
  const [rangeMessages, setRangeMessages] = useState({
    from: 0,
    to: 19,
  });
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

  const nextRange = () => {
    const newRange = {
      from: 0,
      to: (rangeMessages.to + 1) * 2,
    };
    setRangeMessages(newRange);
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
      const messages = (await getMessagesRange(
        rangeMessages.from,
        rangeMessages.to,
      )) as Message[];

      setListMessages(messages.reverse());
    };
    syncMessages();

    const getProfiles = async () => {
      const profilesList = await getAllProfiles();
      setProfiles(profilesList);
    };
    getProfiles();
  }, [rangeMessages]);

  return (
    <div className="space-y-4">
      <button onClick={nextRange} className="p-2 rounded-full btn">
        Cargar mas mensajes
      </button>
      <ChatList profilesList={profiles} messages={optimisticList} />

      <div className="max-w-4xl mx-auto w-full px-4 flex items-center gap-4">
        <div className="w-full">
          <CreateMessageServerAction onSendMessage={onSendMessage} />
        </div>

        <div className="">
          <TestChannel
            onDeleteMessage={deleteMessage}
            onUpdateList={onUpdateListMessage}
            userId={userId}
          />
        </div>
      </div>
    </div>
  );
}
