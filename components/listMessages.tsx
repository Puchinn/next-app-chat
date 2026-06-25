import { DeleteButton } from "@/components/deleteButton";

interface Message {
  id: string;
  content: string;
  author?: string;
  user_id: string;
}

interface ListMessagesProps {
  messages: Message[];
  userId: string | undefined;
}

export function ListMessages({ messages, userId }: ListMessagesProps) {
  return (
    <div className="bg-gray-100 text-blue-200 rounded-md space-y-1 w-full p-2">
      {messages.map((message) => (
        <div
          style={{
            backgroundColor:
              message.user_id === userId ? "var(--color-blue-200)" : "white",
          }}
          className="p-2 text-black flex items-center justify-between rounded-md"
          key={message.id}
        >
          {message.content}
          {message.user_id == userId && <DeleteButton id={message.id} />}
        </div>
      ))}
    </div>
  );
}
