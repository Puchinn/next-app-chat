// Error tipado del dominio chat: nunca se tiran strings.
export class ChatError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ChatError";
  }
}
