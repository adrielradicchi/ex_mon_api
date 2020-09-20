defmodule ExMonWeb.TrainerPokemonsView do
  use ExMonWeb, :view

  alias ExMon.Trainer.Pokemon

  def render("create.json", %{pokemon: %Pokemon{id: id, name: name, nickname: nickname, types: types, weight: weight, trainer_id: trainer_id, inserted_at: inserted_at}}) do
    %{
      message: "Pokemon created!",
      Pokemon: %{
        id: id,
        name: name,
        nickname: nickname,
        types: types,
        weight: weight,
        trainer_id: trainer_id,
        inserted_at: inserted_at
      }
    }
  end

  def render("update.json", %{pokemon: %Pokemon{id: id, name: name, nickname: nickname, types: types, weight: weight, trainer_id: trainer_id, inserted_at: inserted_at, updated_at: updated_at}}) do
    %{
      message: "Pokemon updated!",
      Pokemon: %{
        id: id,
        name: name,
        nickname: nickname,
        types: types,
        weight: weight,
        trainer_id: trainer_id,
        inserted_at: inserted_at,
        updated_at: updated_at
      }
    }
  end

  def render("show.json", %{pokemon: %Pokemon{id: id, name: name, nickname: nickname, types: types, weight: weight, trainer: %{id: trainer_id, name: trainer_name}, inserted_at: inserted_at}}) do
    %{
      id: id,
      name: name,
      nickname: nickname,
      types: types,
      weight: weight,
      trainer: %{
        id: trainer_id,
        name: trainer_name
      },
      inserted_at: inserted_at
    }
  end
end
