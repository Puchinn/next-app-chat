"use client";

import { useState, SubmitEvent } from "react";
import { updateUserInfo } from "@/features/users/actions";
import { User } from "@/features/users/types";

export function Form({ email, user_name }: User) {
  const [loading, setLoading] = useState(false);
  const [inputs, setInputs] = useState({
    user_name: user_name || "Anonimo20200",
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

    try {
      const updated = await updateUserInfo(inputs);
      setLoading(false);
    } catch (error) {
      console.error(error);
      setLoading(false);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-6">
      {loading && (
        <div className="absolute flex items-center justify-center inset-0 w-full h-full bg-white/55">
          <p>Cargando...</p>
        </div>
      )}

      <hr className="border-slate-800" />

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
            value={inputs.user_name}
            onChange={(e) => onInputsChange("user_name", e.target.value)}
          />
        </div>
      </div>

      <div className="space-y-1">
        <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
          Correo
        </p>
        <div className="flex bg-slate-950 opacity-85 border border-slate-800 rounded-lg">
          <span className="pr-1 pl-1 flex items-center text-slate-500">@</span>
          <p className="w-full pr-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-emerald-500 transition-colors">
            {email}
          </p>
        </div>
      </div>

      <button
        type="submit"
        className="w-full flex items-center justify-center space-x-2 bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white font-medium py-2.5 px-4 rounded-lg shadow-lg shadow-emerald-950/50 transition-all active:scale-[0.98]"
      >
        <span>Guardar Cambios</span>
      </button>
    </form>
  );
}
