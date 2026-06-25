import { onDeleteMessage } from "./help";

export function DeleteButton({ id }: { id: string }) {
  const onDelete = async () => {
    await onDeleteMessage({ id });
  };

  return (
    <button onClick={onDelete} title="Eliminar mensaje" className="delete-btn">
      x
    </button>
  );
}
