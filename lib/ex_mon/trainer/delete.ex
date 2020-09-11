defmodule ExMon.Trainer.Delete do

  alias Ecto.UUID
  alias ExMon.{Repo,Trainer}

  def call(id) do
    id
    |> UUID.cast()
    |> validate_uuid()
  end

  defp delete(uuid) do
    uuid
    |> fetch_trainer()
    |> delete_trainer()
  end

  defp validate_uuid({:ok, uuid}), do: delete(uuid)
  defp validate_uuid(:error), do: {:error, "Invalid ID format!"}

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp delete_trainer(trainer) when not is_nil(trainer), do: Repo.delete(trainer)
  defp delete_trainer(_trainer), do: {:error, "Trainer not found"}

end
