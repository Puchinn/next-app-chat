"use server";

import { deleteMessage, createMessage } from "@/services/messages";
import { refresh } from "next/cache";

const onDeleteMessage = async ({ id }: { id: string }) => {
  const { error, success } = await deleteMessage(id);
  refresh();
};

const onCreateMessage = async (message: string) => {
  const data = await createMessage(message);
  return data;
};

const refreshPage = async () => {
  refresh();
};

export { onDeleteMessage, onCreateMessage, refreshPage };
