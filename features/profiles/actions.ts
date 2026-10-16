"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import {
  profileUpdateSchema,
  AVATAR_MIME_EXT,
  AVATAR_MAX_BYTES,
  AVATAR_ERROR_CODES,
} from "./schemas";
import type { ProfileUpdate, AvatarResult } from "./types";
import { ProfilesError } from "./errors";

// Perfil del usuario logueado.
export async function getProfile() {
  const supabase = await createClient();

  const { data, error: userError } = await supabase.auth.getUser();
  if (userError || !data?.user) {
    throw new ProfilesError("No hay usuario logueado.");
  }
  const user = data.user;

  const { data: profile, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();
  if (error || !profile) {
    throw new ProfilesError(
      `Error al obtener el perfil: ${error?.message ?? "sin datos"}`,
    );
  }

  return profile;
}

// Lista de todos los perfiles.
export async function listProfiles() {
  const supabase = await createClient();

  const { data, error } = await supabase.from("profiles").select("*");
  if (error || !data) {
    throw new ProfilesError(
      `Error al listar perfiles: ${error?.message ?? "sin datos"}`,
    );
  }

  return data;
}

// Actualiza campos del propio perfil. Siempre filtra por el id del usuario logueado.
export async function updateProfile(input: ProfileUpdate) {
  const validated = profileUpdateSchema.safeParse(input);
  if (!validated.success) {
    throw new ProfilesError("Input inválido para actualizar el perfil.");
  }
  const supabase = await createClient();

  const { data, error: userError } = await supabase.auth.getUser();
  if (userError || !data?.user) {
    throw new ProfilesError("No hay usuario logueado.");
  }
  const user = data.user;

  const { data: profile, error } = await supabase
    .from("profiles")
    .update(validated.data)
    .eq("id", user.id)
    .select("*")
    .single();
  if (error || !profile) {
    throw new ProfilesError(
      `Error al actualizar el perfil: ${error?.message ?? "sin datos"}`,
    );
  }

  return profile;
}

// Cierre de sesión y redirección al login.
export async function logOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}

// Datos de claims de la sesión actual (null si no hay sesión).
export async function isAuthenticated() {
  const supabase = await createClient();
  const { data } = await supabase.auth.getClaims();
  return data;
}

// Bucket de avatares del dominio.
const AVATAR_BUCKET = "profiles_avatars";

// Prefijo fijo de la URL pública de ese bucket: permite extraer el path
// dentro del bucket a partir de la URL guardada en `profiles.avatar_url`.
const AVATAR_PUBLIC_PREFIX = `/storage/v1/object/public/${AVATAR_BUCKET}/`;

// Extrae el path dentro del bucket a partir de la URL pública.
// Si la URL no tiene el prefijo (p.ej. estárota), devuelve null.
function avatarPathFromPublicUrl(publicUrl: string): string | null {
  const idx = publicUrl.indexOf(AVATAR_PUBLIC_PREFIX);
  if (idx === -1) return null;
  const path = publicUrl.slice(idx + AVATAR_PUBLIC_PREFIX.length);
  return path.length > 0 ? path : null;
}

// Helper local para construir un resultado de error de avatar de forma uniforme.
// El `code` es la fuente de verdad para la UI; el `message` viaja serializado
// hasta el cliente (Next enmascara lanzamientos de server actions en producción).
const avatarFailure = (
  code: (typeof AVATAR_ERROR_CODES)[number],
  message: string,
): AvatarResult => ({ ok: false, code, message });

// Sube el avatar del usuario logueado y persiste la URL pública en el perfil.
// Devuelve siempre un `AvatarResult` serializable: nunca lanza a través de la
// frontera de la server action (los `throw` de `ProfilesError` se convierten en
// resultados en el catch final; los errores de validación se devuelven temprano).
export async function uploadAvatar(file: File): Promise<AvatarResult> {
  // Validar tipo y tamaño antes de tocar almacenamiento.
  const ext = AVATAR_MIME_EXT[file.type];
  if (!ext) {
    return avatarFailure(
      "INVALID_TYPE",
      "Tipo de archivo no permitido. Usa JPEG, PNG, WebP o GIF.",
    );
  }
  if (file.size > AVATAR_MAX_BYTES) {
    return avatarFailure("TOO_LARGE", "La imagen supera el máximo de 2 MB.");
  }

  try {
    // El `try` cubre también `createClient()` y `getUser()`: una excepción
    // de cualquiera de esos (p.ej. env faltante) cae al catch como error
    // inesperado (PROFILE_ERROR, mensaje genérico) y no cruza la acción.
    const supabase = await createClient();

    const { data: userData, error: userError } = await supabase.auth.getUser();
    if (userError || !userData?.user) {
      return avatarFailure("NOT_AUTHENTICATED", "No hay usuario logueado.");
    }
    const user = userData.user;

    // Perfil actual para conocer la URL del avatar anterior (si existe).
    // `getProfile` sigue lanzando `ProfilesError`; si "No hay usuario logueado."
    // la convertemos a NOT_AUTHENTICATED (defensivo, ya chequeamos arriba) y el
    // resto a PROFILE_ERROR (ver catch).
    const profile = await getProfile();
    const oldUrl = profile.avatar_url;

    const storage = supabase.storage.from(AVATAR_BUCKET);

    // Eliminar el avatar anterior (best-effort): si falla, seguimos; el upload
    // puede terminar igualmente. No se usa `upsert`, así que si el remove falló y
    // coincide el path, el upload fallará y ese error SÍ se devuelve (STORAGE_ERROR).
    if (oldUrl) {
      const oldPath = avatarPathFromPublicUrl(oldUrl);
      if (oldPath) {
        await storage.remove([oldPath]); // error ignorado a propósito
      }
    }

    const newPath = `${user.id}/${new Date().valueOf()}-avatar.${ext}`;
    const { error: uploadError } = await storage.upload(newPath, file, {
      cacheControl: "3600",
      upsert: false,
    });
    if (uploadError) {
      // Error de Storage: se devuelve, no se lanza.
      return avatarFailure(
        "STORAGE_ERROR",
        `Error al subir el avatar: ${uploadError.message}`,
      );
    }

    const { data: urlData } = storage.getPublicUrl(newPath);
    const publicUrl = urlData.publicUrl;

    // Persistir la URL pública en el perfil (reutiliza la acción existente;
    // si lanza, el catch lo convierte en PROFILE_ERROR).
    await updateProfile({ avatar_url: publicUrl });

    return { ok: true, avatar_url: publicUrl };
  } catch (err) {
    // Red de seguridad: ninguna `throw` cruza la frontera de la server action.
    if (err instanceof ProfilesError) {
      if (err.message === "No hay usuario logueado.") {
        return avatarFailure("NOT_AUTHENTICATED", err.message);
      }
      return avatarFailure("PROFILE_ERROR", err.message);
    }
    // Error inesperado (no ProfilesError): mensaje genérico en español.
    return avatarFailure(
      "PROFILE_ERROR",
      "Error inesperado al actualizar el avatar.",
    );
  }
}

// Elimina el avatar del usuario logueado y limpia `avatar_url` en el perfil.
// Si no hay avatar, es un no-op idempotente. Devuelve siempre un `AvatarResult`.
export async function deleteAvatar(): Promise<AvatarResult> {
  try {
    // Idem `uploadAvatar`: `createClient()` y `getUser()` dentro del try para
    // que cualquier excepción se convierta en `AvatarResult`, nunca al cliente.
    const supabase = await createClient();

    const { data: userData, error: userError } = await supabase.auth.getUser();
    if (userError || !userData?.user) {
      return avatarFailure("NOT_AUTHENTICATED", "No hay usuario logueado.");
    }

    // `getProfile` puede lanzar; si es "No hay usuario logueado." (defensivo)
    // → NOT_AUTHENTICATED; lo demás va al catch como PROFILE_ERROR.
    const profile = await getProfile();
    const oldUrl = profile.avatar_url;

    // Sin avatar: nada que hacer (decisión P7 de la spec).
    if (!oldUrl) {
      return { ok: true, avatar_url: null };
    }

    const oldPath = avatarPathFromPublicUrl(oldUrl);
    if (!oldPath) {
      // URL rotada / no del bucket esperado: se devuelve STORAGE_ERROR.
      return avatarFailure(
        "STORAGE_ERROR",
        "La URL del avatar no corresponde al bucket esperado.",
      );
    }

    const { error: removeError } = await supabase.storage
      .from(AVATAR_BUCKET)
      .remove([oldPath]);
    if (removeError) {
      // Error de Storage: se devuelve, no se lanza.
      return avatarFailure(
        "STORAGE_ERROR",
        `Error al eliminar el avatar: ${removeError.message}`,
      );
    }

    // Limpiar la URL en el perfil (reutiliza la acción existente; si lanza,
    // el catch lo convierte en PROFILE_ERROR).
    await updateProfile({ avatar_url: null });

    return { ok: true, avatar_url: null };
  } catch (err) {
    if (err instanceof ProfilesError) {
      if (err.message === "No hay usuario logueado.") {
        return avatarFailure("NOT_AUTHENTICATED", err.message);
      }
      return avatarFailure("PROFILE_ERROR", err.message);
    }
    return avatarFailure(
      "PROFILE_ERROR",
      "Error inesperado al actualizar el avatar.",
    );
  }
}
