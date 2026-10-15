"use client";

import { useState, SubmitEvent } from "react";
import { Loader2 } from "lucide-react";
import { updateProfile } from "@/features/profiles";
import type { Profile, ProfileUpdate } from "@/features/profiles";

export function Form({ email, username }: Profile) {
  const [loading, setLoading] = useState(false);
  const [saved, setSaved] = useState(false);
  const [inputs, setInputs] = useState<ProfileUpdate>({
    username: username || "Anonimo20200",
  });

  const onInputsChange = (field: keyof typeof inputs, value: string) => {
    setInputs((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const onSubmit = async (e: SubmitEvent) => {
    e.preventDefault();
    setLoading(true);
    setSaved(false);

    try {
      await updateProfile(inputs);
      setLoading(false);
      setSaved(true);
    } catch (error) {
      console.error(error);
      setLoading(false);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-6">
      <div className="space-y-1.5">
        <label
          className="block text-sm font-medium text-tinta"
          htmlFor="username"
        >
          Nombre de usuario
        </label>
        <div className="flex w-full items-center rounded-lg border border-borde bg-papel-alto transition-colors focus-within:border-tinta">
          <span aria-hidden="true" className="pl-3 text-tinta-suave">
            @
          </span>
          <input
            type="text"
            name="username"
            id="username"
            minLength={3}
            required
            className="w-full min-w-0 bg-transparent px-2 py-2.5 text-sm text-tinta placeholder:text-tinta-suave/70 focus:outline-none"
            placeholder="usuario"
            value={inputs.username ?? ""}
            onChange={(e) => onInputsChange("username", e.target.value)}
          />
        </div>
      </div>

      <div className="space-y-1.5">
        <span className="block text-sm font-medium text-tinta">Correo</span>
        <div className="flex w-full items-center rounded-lg border border-borde bg-papel px-3 py-2.5 text-sm text-tinta-suave">
          <span aria-hidden="true" className="mr-1">
            @
          </span>
          {email}
        </div>
      </div>

      <button type="submit" disabled={loading} className="btn w-full py-2.5">
        {loading && (
          <Loader2
            className="h-4 w-4 animate-spin motion-reduce:animate-none"
            aria-hidden="true"
          />
        )}
        {loading ? "Guardando…" : "Guardar cambios"}
      </button>

      {/* Región viva: anuncia el éxito sin mover el foco. */}
      <p role="status" aria-live="polite" className="text-sm text-verde">
        {saved ? "Cambios guardados." : ""}
      </p>
    </form>
  );
}
