"use client";

import { SubmitEvent, useState } from "react";
import { useRouter } from "next/navigation";

import { supabaseClient } from "@/lib/supabase/client";

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

    const { data, error } = await supabaseClient.auth.signInWithPassword({
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
    await supabaseClient.auth.setSession(data.session);
    router.replace("/");
  };

  return (
    <section className=" py-20">
      {loading && (
        <div className="absolute inset-0 w-full h-full">Cargando...</div>
      )}

      <form
        className=" mx-auto space-y-2 max-w-md w-full p-2 shadow-md shadow-gray-200 rounded-2xl"
        onSubmit={onSubmit}
      >
        <h2 className="text-center text-2xl">Login</h2>

        <label className="flex flex-col" htmlFor="email">
          Email:
          <input
            className="p-2 border border-gray-100 rounded-xl bg-gray-50"
            type="email"
            name="email"
            id="email"
          />
        </label>

        <label className="flex flex-col" htmlFor="password">
          Password:
          <input
            className="p-2 border border-gray-100 rounded-xl bg-gray-50"
            type="password"
            name="password"
            id="password"
          />
        </label>

        <button
          className="rounded-md p-3 bg-gray-100 border border-gray-300"
          type="submit"
        >
          Entrar
        </button>

        {dataError.error && (
          <p className="text-red-500"> Mensaje: {dataError.message} </p>
        )}
      </form>

      <div className=" py-6 mx-auto text-center">
        <p className="font-thin text-sm text-black/85">sin cuenta?</p>
        <button className="rounded-md p-3 bg-gray-100 border border-gray-300">
          Crear cuenta
        </button>
      </div>
    </section>
  );
}
