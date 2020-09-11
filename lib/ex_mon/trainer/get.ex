defmodule ExMon.Trainer.Get do

  alias Ecto.UUID
  alias ExMon.{Repo,Trainer}

  def call(id) do
    id
    |> UUID.cast()
    |> validate_uuid()
  end

  defp get(uuid) do
    uuid
    |> fetch_trainer()
    |> get_trainer()
  end

  defp validate_uuid({:ok, uuid}), do: get(uuid)
  defp validate_uuid(:error), do: {:error, "Invalid ID format!"}

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp get_trainer(trainer) when not is_nil(trainer), do: {:ok, trainer}
  defp get_trainer(_trainer), do: {:error, "Trainer not found"}

end
