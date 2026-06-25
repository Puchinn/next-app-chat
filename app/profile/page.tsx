import { LogOutButton } from "@/components/logOut";
import Link from "next/link";
import { getProfileInfo } from "@/services/profile";
import { Form } from "./form";

export default async function Page() {
  const data = await getProfileInfo();

  return (
    <div className="p-2 space-y-2">
      <nav className="bg-gray-50 p-2 flex items-center w-full gap-3 rounded-md border border-gray-200">
        <div className="flex-1 h-auto">
          <h2>APPCITA</h2>
        </div>
        <LogOutButton />
        <Link
          href={"/"}
          className="shadow-md my-2 p-2 rounded-md border border-gray-200 bg-gray-50"
        >
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
