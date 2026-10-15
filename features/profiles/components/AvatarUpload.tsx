"use client";

import { useEffect, useRef, useState } from "react";
import type { ChangeEvent } from "react";
import { Image, Loader2 } from "lucide-react";

import { AVATAR_MAX_BYTES, AVATAR_MIME_EXT } from "../schemas";
import { deleteAvatar, uploadAvatar } from "../actions";

type AvatarUploadProps = {
  avatarUrl: string | null;
  username: string | null;
};

const ACCEPT_TYPES = Object.keys(AVATAR_MIME_EXT).join(",");
const ALLOWED_MIME_TYPES = Object.keys(AVATAR_MIME_EXT);

function getInitials(username: string | null): string {
  const name = username?.trim();
  if (!name) return "US";
  const letters = name.replace(/\s+/g, " ").split(" ").filter(Boolean);
  if (letters.length === 1) return letters[0].slice(0, 2).toUpperCase();
  return (letters[0][0] + letters[1][0]).toUpperCase();
}

function toErrorMessage(err: unknown): string {
  return err instanceof Error ? err.message : "Error al actualizar el avatar.";
}

export function AvatarUpload({ avatarUrl, username }: AvatarUploadProps) {
  // Estado local (aviso: el server re-valida todo igual).
  const [currentAvatar, setCurrentAvatar] = useState<string | null>(avatarUrl);
  const [file, setFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Ref al objectURL vigente para poder revocarlo en el unmount.
  const previewRef = useRef<string | null>(null);
  useEffect(() => {
    previewRef.current = previewUrl;
    return () => {
      const toRevoke = previewRef.current;
      if (toRevoke) URL.revokeObjectURL(toRevoke);
      previewRef.current = null;
    };
  }, [previewUrl]);

  const replacePreview = (next: string | null) => {
    // Revoca el vigente y asigna el nuevo (o null) en un solo estado.
    setPreviewUrl((prev) => {
      if (prev && prev !== next) URL.revokeObjectURL(prev);
      return next;
    });
  };

  const onFileChange = (e: ChangeEvent<HTMLInputElement>) => {
    const selected = e.target.files?.[0] ?? null;

    if (!selected) {
      // Limpiar el input sin elegir nada: resetea todo.
      replacePreview(null);
      setFile(null);
      setError(null);
      setSuccess(null);
      e.target.value = "";
      return;
    }

    if (!ALLOWED_MIME_TYPES.includes(selected.type)) {
      setError("Tipo de archivo no permitido. Usa JPEG, PNG, WebP o GIF.");
      e.target.value = "";
      return;
    }

    if (selected.size > AVATAR_MAX_BYTES) {
      setError("La imagen supera el máximo de 2 MB.");
      e.target.value = "";
      return;
    }

    const url = URL.createObjectURL(selected);
    replacePreview(url);
    setFile(selected);
    setError(null);
    setSuccess(null);
    e.target.value = "";
  };

  const onUpload = async () => {
    if (busy || !file) return;
    setBusy(true);
    setError(null);
    setSuccess(null);

    try {
      const result = await uploadAvatar(file);
      if (result.ok) {
        // avatar_url puede llegar undefined según el schema; normalizamos a null.
        setCurrentAvatar(result.avatar_url ?? null);
        setFile(null);
        replacePreview(null);
        setSuccess("Avatar actualizado.");
      } else {
        setError(result.message);
      }
    } catch (err: unknown) {
      setError(toErrorMessage(err));
    } finally {
      setBusy(false);
    }
  };

  const onDelete = async () => {
    if (busy) return;
    setBusy(true);
    setError(null);
    setSuccess(null);

    try {
      const result = await deleteAvatar();
      if (result.ok) {
        setCurrentAvatar(result.avatar_url ?? null);
        setSuccess("Avatar eliminado.");
      } else {
        setError(result.message);
      }
    } catch (err: unknown) {
      setError(toErrorMessage(err));
    } finally {
      setBusy(false);
    }
  };

  const canUpload = file !== null && !busy;
  const canDelete = currentAvatar !== null && !busy && previewUrl === null;

  const effectiveSrc = previewUrl ?? currentAvatar;
  const alt = username
    ? `Avatar de ${username}`
    : "Avatar del usuario";

  return (
    <section className="space-y-4">
      <div className="flex flex-col items-center gap-4 rounded-xl border border-borde bg-papel-alto p-5">
        {effectiveSrc ? (
          <img
            src={effectiveSrc}
            alt={alt}
            className="h-24 w-24 rounded-full object-cover"
          />
        ) : (
          <span className="flex h-24 w-24 items-center justify-center rounded-full bg-tinta font-display text-2xl font-medium text-papel">
            {getInitials(username)}
          </span>
        )}

        <div className="w-full max-w-sm space-y-2">
          <label
            htmlFor="avatar-file-input"
            className="block text-sm text-tinta-suave"
          >
            Imagen (JPEG, PNG, WebP o GIF · máx. 2 MB)
          </label>

          <div className="flex rounded-lg border border-borde bg-papel-alto">
            <span className="flex items-center pl-3 pr-1 text-tinta-suave">
              <Image className="h-4 w-4" aria-hidden="true" />
            </span>
            <input
              id="avatar-file-input"
              name="avatar"
              type="file"
              accept={ACCEPT_TYPES}
              disabled={busy}
              onChange={onFileChange}
              className="w-full pr-3 py-2 text-sm text-tinta focus:outline-none transition-colors"
            />
          </div>
        </div>

        <div className="w-full max-w-sm flex gap-2">
          <button
            type="button"
            onClick={onUpload}
            disabled={!canUpload}
            className="flex-1 flex items-center justify-center space-x-2 rounded-lg bg-verde text-white font-medium py-2.5 px-4 hover:bg-verde-hover disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
          >
            {busy && (
              <Loader2
                className="h-4 w-4 animate-spin motion-reduce:animate-none"
                aria-hidden="true"
              />
            )}
            <span>{busy ? "Subiendo…" : "Subir avatar"}</span>
          </button>

          {canDelete && (
            <button
              type="button"
              onClick={onDelete}
              disabled={busy}
              className="flex items-center justify-center space-x-1 rounded-lg border border-borde bg-papel-alto text-tinta font-medium py-2.5 px-4 hover:border-error hover:text-error disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              {busy && (
                <Loader2
                  className="h-4 w-4 animate-spin motion-reduce:animate-none"
                  aria-hidden="true"
                />
              )}
              <span>{busy ? "Eliminando…" : "Eliminar avatar"}</span>
            </button>
          )}
        </div>

        <div
          role="status"
          aria-live="polite"
          className="w-full max-w-sm min-h-[1.5rem] text-sm"
        >
          {error && (
            <p className="rounded-lg border border-borde bg-papel px-3 py-2 text-error">
              {error}
            </p>
          )}
          {!error && success && (
            <p className="rounded-lg bg-verde px-3 py-2 text-white">
              {success}
            </p>
          )}
        </div>
      </div>
    </section>
  );
}
