defmodule ExMon.Trainer.Pokemon.Get do

  alias Ecto.UUID
  alias ExMon.{Repo,Trainer.Pokemon}

  def call(id) do
    id
    |> UUID.cast()
    |> validate_uuid()
  end

  defp get(uuid) do
    uuid
    |> fetch_pokemon()
    |> get_pokemon()
  end

  defp validate_uuid({:ok, uuid}), do: get(uuid)
  defp validate_uuid(:error), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp fetch_pokemon(uuid), do: Repo.get(Pokemon, uuid)

  defp get_pokemon(pokemon) when not is_nil(pokemon), do: {:ok, Repo.preload(pokemon, :trainer)}
  defp get_pokemon(_pokemon), do: {:error, %{message: "Pokemon not found", status: 404}}

end
