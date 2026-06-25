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
    <div className="card p-2 space-y-1 w-full">
      {messages.map((message) => (
        <div
          className={`p-2 text-black flex items-center justify-between rounded-md ${
            message.user_id === userId ? "bg-blue-200" : "bg-white"
          }`}
          key={message.id}
        >
          {message.content}
          {message.user_id == userId && <DeleteButton id={message.id} />}
        </div>
      ))}
    </div>
  );
}
