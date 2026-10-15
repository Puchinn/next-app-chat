import { Send } from "lucide-react";
import { SubmitEvent } from "react";

export function CreateMessageServerAction({
  onSendMessage,
}: {
  onSendMessage: (message: string) => void;
}) {
  const onSubmitForm = (event: SubmitEvent) => {
    event.preventDefault();
    const formData = new FormData(event.target);

    const message = formData.get("message")?.toString() || "";
    onSendMessage(message);
    const input = event.target.querySelector("input");
    if (input) {
      input.value = "";
    }
  };

  return (
    <form onSubmit={onSubmitForm}>
      <div className="flex w-full items-center gap-3">
        <label htmlFor="message" className="sr-only">
          Mensaje
        </label>
        <input
          className="input min-w-0 flex-1"
          placeholder="Escribe un mensaje..."
          name="message"
          id="message"
        />
        <button
          type="submit"
          aria-label="Enviar mensaje"
          className="btn shrink-0 p-2.5"
        >
          <Send className="h-5 w-5" aria-hidden="true" />
        </button>
      </div>
    </form>
  );
}
