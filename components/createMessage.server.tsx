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
              className="border rounded-2xl p-3 text-black/90 border-gray-300 w-full"
              placeholder="Escribir mensaje..."
              name="message"
              id="message"
            />
          </label>
          <button
            type="submit"
            className="rounded-full cursor-pointer p-2 text-2xl border bg-gray-100 border-gray-300"
          >
            📤
          </button>
        </div>
      </form>
    </section>
  );
}
