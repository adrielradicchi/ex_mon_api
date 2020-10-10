defmodule ExMonWeb.TrainersView do
  use ExMonWeb, :view

  alias ExMon.{Trainer, Trainer.Pokemon}

  def render("create.json", %{trainer: %Trainer{id: id, name: name, inserted_at: inserted_at}, token: token}) do
    %{
      message: "Trainer created!",
      trainer: %{
        id: id,
        name: name,
        inserted_at: inserted_at
      },
      token: token
    }
  end

  def render("sign_in.json", %{token: token}), do: %{token: token}

  def render("update.json", %{trainer: %Trainer{id: id, name: name, inserted_at: inserted_at, updated_at: updated_at}}) do
    %{
      message: "Trainer updated!",
      trainer: %{
        id: id,
        name: name,
        inserted_at: inserted_at,
        updated_at: updated_at
      }
    }
  end

  def render("show.json", %{trainer: %Trainer{id: id, name: name, pokemon: pokemons, inserted_at: inserted_at}}) do
    %{
      id: id,
      name: name,
      pokemon: map_pokemons(pokemons),
      inserted_at: inserted_at
    }
  end

  defp map_pokemons(pokemons) do
    pokemons
    |> Enum.map(&show_pokemon&1)
  end

  defp show_pokemon(%Pokemon{id: id, name: name, nickname: nickname, types: types, weight: weight, trainer_id: trainer_id, inserted_at: inserted_at}) do
    %{
      id: id,
      name: name,
      nickname: nickname,
      types: types,
      weight: weight,
      trainer_id: trainer_id,
      inserted_at: inserted_at
    }
  end
end
