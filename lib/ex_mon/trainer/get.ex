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
  defp validate_uuid(:error), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp get_trainer(trainer) when not is_nil(trainer), do: {:ok, Repo.preload(trainer, :pokemon)}
  defp get_trainer(_trainer), do: {:error, %{message: "Trainer not found", status: 404}}

end
