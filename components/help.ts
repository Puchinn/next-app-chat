"use server";

import { deleteMessage, createMessage } from "@/features/chat";
import { refresh } from "next/cache";

const onDeleteMessage = async ({ id }: { id: string }) => {
  await deleteMessage(id);
  refresh();
};

const onCreateMessage = async (message: string) => {
  const data = await createMessage({ content: message });
  return data;
};

const refreshPage = async () => {
  refresh();
};

export { onDeleteMessage, onCreateMessage, refreshPage };
