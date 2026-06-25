import { onDeleteMessage } from "./help";

export function DeleteButton({ id }: { id: string }) {
  const onDelete = async () => {
    await onDeleteMessage({ id });
  };

  return (
    <button
      onClick={onDelete}
      title="Eliminar mensaje"
      className="w-9 h-9 flex justify-center items-center rounded-full text-slate-500 hover:text-rose-400 hover:bg-slate-800/80 opacity-0 group-hover:opacity-100 transition-all duration-200"
    >
      x
    </button>
  );
}
