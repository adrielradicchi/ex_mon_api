defmodule ExMon.Trainer.Pokemon.Create do
  alias Ecto.UUID
  alias ExMon.PokeApi.Client
  alias ExMon.{Repo, Pokemon, Trainer}
  alias ExMon.Trainer.Pokemon, as: TrainerPokemon
  def call(%{"name" => name} = params) do
    name
    |> Client.get_pokemon()
    |> handle_response(params)
  end

  defp handle_response({:ok, body}, params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  defp handle_response({:error, _msg} = error, _params), do: error

  defp create_pokemon(%Pokemon{name: name, weight: weight, types: types}, %{"nickname" => nickname, "trainer_id" => trainer_id}) do
    params = %{
      name: name,
      weight: weight,
      types: types,
      nickname: nickname,
      trainer_id: trainer_id
    }

    params
    |> validate()
    |> TrainerPokemon.build()
    |> handle_build()
  end

  defp validate(%{trainer_id: trainer_id} = pokemon) do
    trainer_id
    |> UUID.cast()
    |> validate_trainer(pokemon)
  end

  defp validate_trainer({:ok, trainer_id}, pokemon), do: get_trainer(trainer_id, pokemon)
  defp validate_trainer(:error, _pokemon), do: {:error, %{message: "Invalid ID format!", status: 400}}

  defp get_trainer(trainer_id, pokemon) do
    trainer_id
    |> fetch_trainer(pokemon)
    |> get_pokemon()
  end

  defp fetch_trainer(trainer_id, pokemon), do: {Repo.get(Trainer, trainer_id), pokemon}

  defp get_pokemon({trainer, pokemon}) when not is_nil(trainer), do: pokemon
  defp get_pokemon({_trainer, _pokemon}), do: {:error, %{message: "Trainer not found", status: 404}}

  defp handle_build({:ok, pokemon}), do: Repo.insert(pokemon)
  defp handle_build({:error, _changeset} = error), do: error
end
