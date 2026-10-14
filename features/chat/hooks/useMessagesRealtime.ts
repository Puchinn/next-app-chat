"use client";

import type { z } from "zod";
import { useEffect, useState } from "react";
import type { RealtimePostgresChangesPayload } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/client";
import { messageSchema } from "../schemas";
import type { RealtimeEventPayload } from "../types";

type Message = z.infer<typeof messageSchema>;

// Hook que se suscribe por realtime a la tabla `messages` y expone los
// últimos eventos recibidos (INSERT / UPDATE / DELETE). El acceso a datos
// por query vive en actions.ts; acá solo hay suscripción realtime.
export function useMessagesRealtime(): {
  events: RealtimeEventPayload[];
  error: string | null;
  isConnected: boolean;
} {
  const [events, setEvents] = useState<RealtimeEventPayload[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    let disposed = false;

    const supabase = createClient();

    const channel = supabase
      .channel("messages-realtime")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "messages" },
        (payload: RealtimePostgresChangesPayload<Record<string, unknown>>) => {
          const normalized = normalizePayload(payload);
          if (normalized && !disposed) {
            setEvents((prev) => [...prev, normalized]);
          }
        },
      )
      .subscribe((status) => {
        if (disposed) return;
        if (status === "SUBSCRIBED") {
          setIsConnected(true);
          setError(null);
        } else if (status === "CHANNEL_ERROR" || status === "TIMED_OUT" || status === "CLOSED") {
          setIsConnected(false);
          setError(`Canal realtime en estado: ${status}`);
        }
      });

    return () => {
      disposed = true;
      void supabase.removeChannel(channel);
    };
  }, []);

  return { events, error, isConnected };
}

// El payload de Supabase trae las filas como `Record<string, string | null>`.
// Lo casteanos a `Message` recién después de validar las columnas que
// `messageSchema` declara requeridas, sin tocar `any`.
function normalizePayload(
  payload: RealtimePostgresChangesPayload<Record<string, unknown>>,
): RealtimeEventPayload | null {
  const raw = payload as {
    eventType: string;
    new: Record<string, string | null> | null;
    old: Record<string, string | null> | null;
  };

  if (raw.eventType === "INSERT") {
    if (!isValidMessage(raw.new)) return null;
    return { eventType: "INSERT", new: raw.new as unknown as Message, old: null };
  }

  if (raw.eventType === "UPDATE") {
    if (!isValidMessage(raw.new) || !isValidMessage(raw.old)) return null;
    return {
      eventType: "UPDATE",
      new: raw.new as unknown as Message,
      old: raw.old as unknown as Message,
    };
  }

  if (raw.eventType === "DELETE") {
    if (!hasId(raw.old)) return null;
    return { eventType: "DELETE", new: null, old: raw.old as unknown as Message };
  }

  return null;
}

// Para DELETE solo necesitamos `old.id`: el contrato (spec 01 REQ-5) prevé
// `REPLICA IDENTITY FULL` con `old` completo, pero en runtime el payload de
// DELETE puede llegar truncado y el único campo consumido aguas abajo
// (components/messagesModule.tsx → applyRealtimeEvent) es `old.id`.
function hasId(row: Record<string, string | null> | null): boolean {
  return !!row && typeof row.id === "string" && row.id.length > 0;
}

// Solo valida que las columnas requeridas por `messageSchema` existan con
// tipo string no-vacío. Si falta alguna, descartamos el evento.
function isValidMessage(row: Record<string, string | null> | null): boolean {
  if (!row) return false;
  if (typeof row.id !== "string" || row.id.length === 0) return false;
  if (typeof row.created_at !== "string" || row.created_at.length === 0) return false;
  return true;
}
