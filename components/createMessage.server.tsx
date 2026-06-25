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
    <section className="space-y-1">
      <form onSubmit={onSubmitForm}>
        <div className="flex items-center w-full gap-x-4">
          <label htmlFor="message" className="w-full">
            <input
              className="input"
              placeholder="Escribir mensaje..."
              name="message"
              id="message"
            />
          </label>
          <button type="submit" className="icon-btn" aria-label="Enviar">
            📤
          </button>
        </div>
      </form>
    </section>
  );
}
