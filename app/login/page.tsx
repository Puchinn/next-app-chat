"use client";

import { SubmitEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";

import { createClient } from "@/lib/supabase/client";

export default function Page() {
  const [loading, setLoading] = useState(false);
  const [dataError, setDataError] = useState({
    error: false,
    message: "",
  });
  const router = useRouter();

  const onSubmit = async (event: SubmitEvent) => {
    event.preventDefault();
    setLoading(true);
    const formData = new FormData(event.target);

    const email = formData.get("email")?.toString() || "";
    const password = formData.get("password")?.toString() || "";

    const supabase = createClient();

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setDataError({
        error: true,
        message: error.message,
      });

      setLoading(false);
      return;
    }

    setLoading(false);
    await supabase.auth.setSession(data.session);
    router.replace("/");
  };

  return (
    <section className="flex min-h-dvh items-center justify-center bg-papel px-4 py-12">
      <form
        className="card mx-auto w-full max-w-md space-y-5 p-8"
        onSubmit={onSubmit}
      >
        <header className="space-y-1 text-center">
          <p className="font-display text-sm text-verde">APPCITA</p>
          <h1 className="font-display text-2xl text-tinta">Iniciar sesión</h1>
        </header>

        <div className="space-y-1.5">
          <label
            className="block text-sm font-medium text-tinta"
            htmlFor="email"
          >
            Correo
          </label>
          <input
            className="input w-full"
            type="email"
            name="email"
            id="email"
            autoComplete="email"
          />
        </div>

        <div className="space-y-1.5">
          <label
            className="block text-sm font-medium text-tinta"
            htmlFor="password"
          >
            Contraseña
          </label>
          <input
            className="input w-full"
            type="password"
            name="password"
            id="password"
            autoComplete="current-password"
          />
        </div>

        <button className="btn w-full py-2.5" type="submit" disabled={loading}>
          {loading && (
            <Loader2
              className="h-4 w-4 animate-spin motion-reduce:animate-none"
              aria-hidden="true"
            />
          )}
          {loading ? "Entrando…" : "Entrar"}
        </button>

        {dataError.error && (
          <p role="alert" className="text-sm text-error">
            {dataError.message}
          </p>
        )}
      </form>
    </section>
  );
}
