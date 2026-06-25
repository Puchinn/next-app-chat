import { LogOutButton } from "@/components/logOut";
import Link from "next/link";
import { getProfileInfo } from "@/services/profile";
import { Form } from "./form";

export default async function Page() {
  const data = await getProfileInfo();

  return (
    <div className="p-2 space-y-2">
      <nav className="card flex items-center max-w-7xl mx-auto w-full gap-3 p-3">
        <div className="flex-1 h-auto">
          <h2 className="text-lg font-bold text-slate-100">APPCITA</h2>
        </div>
        <LogOutButton />
        <Link href={"/"} className="btn">
          Home
        </Link>
      </nav>

      <div className="max-w-md mx-auto my-10 bg-slate-900 text-white rounded-2xl shadow-xl overflow-hidden border border-slate-800">
        <div className="p-8">
          <h2 className="text-2xl font-bold text-center mb-6 bg-gradient-to-r from-emerald-400 to-teal-500 bg-clip-text text-transparent">
            Editar Perfil
          </h2>

          <Form {...data} />
        </div>
      </div>
    </div>
  );
}
