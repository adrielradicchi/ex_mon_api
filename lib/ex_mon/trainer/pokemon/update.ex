defmodule ExMon.Trainer.Pokemon.Update do

  alias Ecto.UUID
  alias ExMon.{Repo, Trainer.Pokemon}

  def call(%{"id" => uuid} = params) do
    uuid
    |> UUID.cast()
    |> validate_uuid(params)
  end

  defp update(%{"id" => uuid} = params) do
    uuid
    |> fetch_pokemon()
    |> update_pokemon(params)
  end

  defp validate_uuid({:ok, _uuid}, params), do: update(params)
  defp validate_uuid(:error, _params), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp fetch_pokemon(uuid), do: Repo.get(Pokemon, uuid)

  defp update_pokemon(pokemon, params) when not is_nil(pokemon) do
    pokemon
    |> Pokemon.update_changeset(params)
    |> Repo.update()
  end

  defp update_pokemon(_pokemon, _params), do: {:error, %{message: "Pokemon not found", status: 404}}

end
