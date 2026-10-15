import { AppShell } from "@/components/appShell";
import { Form } from "./form";
import { AvatarUpload, getProfile } from "@/features/profiles";

export default async function Page() {
  const user = await getProfile();

  return (
    <AppShell activeItem="profile">
      <div className="flex flex-1 flex-col items-center overflow-y-auto px-4 py-8">
        <div className="card w-full max-w-md p-8">
          <h1 className="mb-6 text-center font-display text-2xl text-tinta">
            Editar perfil
          </h1>

          <Form {...user} />

          <h2 className="mb-4 mt-8 text-sm font-medium text-tinta-suave">
            Foto de perfil
          </h2>
          <AvatarUpload
            avatarUrl={user.avatar_url ?? null}
            username={user.username ?? null}
          />
        </div>
      </div>
    </AppShell>
  );
}
