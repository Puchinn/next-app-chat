import { Trash2 } from "lucide-react";
import { onDeleteMessage } from "./help";

export function DeleteButton({ id }: { id: string }) {
  const onDelete = async () => {
    await onDeleteMessage({ id });
  };

  return (
    <button
      type="button"
      onClick={onDelete}
      aria-label="Eliminar mensaje"
      className="shrink-0 rounded-lg p-1.5 text-tinta-suave opacity-0 transition-opacity hover:bg-papel-alto hover:text-error focus-visible:opacity-100 group-hover:opacity-100 group-focus-within:opacity-100"
    >
      <Trash2 className="h-4 w-4" aria-hidden="true" />
    </button>
  );
}
