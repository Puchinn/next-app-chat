// Error tipado del dominio profiles: nunca se tiran strings.
export class ProfilesError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ProfilesError";
  }
}
