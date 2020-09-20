defmodule ExMon.Trainer.Pokemon.Delete do

  alias Ecto.UUID
  alias ExMon.{Repo, Trainer.Pokemon}

  def call(id) do
    id
    |> UUID.cast()
    |> validate_uuid()
  end

  defp delete(uuid) do
    uuid
    |> fetch_pokemon()
    |> delete_pokemon()
  end

  defp validate_uuid({:ok, uuid}), do: delete(uuid)
  defp validate_uuid(:error), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp fetch_pokemon(uuid), do: Repo.get(Pokemon, uuid)

  defp delete_pokemon(pokemon) when not is_nil(pokemon), do: Repo.delete(pokemon)
  defp delete_pokemon(_trainer), do: {:error, %{message: "Pokemon not found", status: 404}}

end
