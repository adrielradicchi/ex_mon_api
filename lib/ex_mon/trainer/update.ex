defmodule ExMon.Trainer.Update do

  alias Ecto.UUID
  alias ExMon.{Repo,Trainer}

  def call(%{"id" => uuid} = params) do
    uuid
    |> UUID.cast()
    |> validate_uuid(params)
  end

  defp update(%{"id" => uuid} = params) do
    uuid
    |> fetch_trainer()
    |> update_trainer(params)
  end

  defp validate_uuid({:ok, _uuid}, params), do: update(params)
  defp validate_uuid(:error, _params), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp update_trainer(trainer, params) when not is_nil(trainer) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end

  defp update_trainer(_trainer, _params), do: {:error, %{message: "Trainer not found", status: 404}}

end
