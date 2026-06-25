"use client";

import type { Profile } from "@/services/profile";
import { ChangeEvent, useState } from "react";
import { updateProfileInfo } from "@/services/profile";

export function Form({ avatar_url, full_name, email, username, id }: Profile) {
  const [loading, setLoading] = useState(false);
  const [inputUrl, setInputUrl] = useState(avatar_url);
  const [inputs, setInputs] = useState({
    full_name,
    username,
  });

  const onInputsChange = (field: keyof typeof inputs, value: string) => {
    setInputs((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const onInputUrlChange = (e: ChangeEvent<HTMLInputElement>) => {
    setInputUrl(e.target.value);
  };

  const onSubmit = async () => {
    setLoading(true);
    try {
      const { message } = await updateProfileInfo({
        ...inputs,
        avatar_url: inputUrl,
        id,
      });
      setLoading(false);
      alert(message);
    } catch (error) {
      setLoading(false);
      alert(error);
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-6">
      {loading && (
        <div className="absolute flex items-center justify-center inset-0 w-full h-full bg-white/55">
          <p>Cargando...</p>
        </div>
      )}
      {/* SECCIÓN DEL AVATAR */}
      <div className="flex flex-col items-center justify-center space-y-3">
        {/* Preview Redonda */}
        <img
          src={inputUrl || `https://ui-avatars.com/api/?name=${email}`}
          alt="Avatar preview"
          className="w-50 h-50 object-cover block rounded-full border-4 border-emerald-500/30 group-hover:border-emerald-500 transition-colors duration-300"
        />
      </div>

      <hr className="border-slate-800" />

      {/* CAMPO: URL DEL AVATAR (Por si prefieren pegar un link directo) */}
      <div className="space-y-1">
        <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
          URL del Avatar
        </label>
        <input
          type="text"
          name="avatar_url"
          value={inputUrl}
          onChange={onInputUrlChange}
          className="w-full bg-slate-950 border border-slate-800 rounded-lg px-3 py-2 text-sm text-slate-300 focus:outline-none focus:border-emerald-500 transition-colors"
          placeholder="https://ejemplo.com/foto.jpg"
        />
      </div>

      {/* CAMPO: USERNAME */}
      <div className="space-y-1">
        <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
          Nombre de Usuario
        </label>
        <div className="flex bg-slate-950 border border-slate-800 rounded-lg">
          <span className="pr-1 pl-1 flex items-center text-slate-500">@</span>
          <input
            type="text"
            name="username"
            minLength={3}
            required
            className="w-full pr-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-emerald-500 transition-colors"
            placeholder="usuario"
            value={inputs.username}
            onChange={(e) => onInputsChange("username", e.target.value)}
          />
        </div>
      </div>

      {/* CAMPO: FULL NAME */}
      <div className="space-y-1">
        <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
          Nombre Completo
        </label>
        <input
          type="text"
          name="full_name"
          className="w-full bg-slate-950 border border-slate-800 rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-emerald-500 transition-colors"
          placeholder="Tu Nombre"
          value={inputs.full_name}
          onChange={(e) => onInputsChange("full_name", e.target.value)}
        />
      </div>

      {/* BOTÓN GUARDAR */}
      <button
        type="submit"
        className="w-full flex items-center justify-center space-x-2 bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white font-medium py-2.5 px-4 rounded-lg shadow-lg shadow-emerald-950/50 transition-all active:scale-[0.98]"
      >
        <span>Guardar Cambios</span>
      </button>
    </form>
  );
}
