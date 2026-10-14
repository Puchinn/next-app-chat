"use client";

import { createMessage } from "@/features/chat";
import { useState } from "react";
import { useRouter } from "next/navigation";

interface Inputs {
  message: string;
  author?: string;
}

export function CreateMessageClient() {
  const router = useRouter();
  const [inputs, setInputs] = useState<Inputs>({
    message: "",
    author: "",
  });

  const onChangeInput = (field: keyof Inputs, value: string) => {
    setInputs({
      ...inputs,
      [field]: value,
    });
  };

  const onCreateMessage = async () => {
    try {
      const data = await createMessage({ content: inputs.message });
      router.refresh();
      console.log(data);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <section className="space-y-1">
      <p>Mensaje:</p>
      <textarea
        className="input h-28 resize-none"
        name="message"
        id="message"
        value={inputs.message}
        onChange={(e) => onChangeInput("message", e.target.value)}
      ></textarea>

      <p>Author:</p>
      <input
        value={inputs.author}
        className="input"
        type="text"
        name="author"
        id="author"
        onChange={(e) => onChangeInput("author", e.target.value)}
      />

      <button onClick={onCreateMessage} className="btn">
        Enviar
      </button>
    </section>
  );
}
