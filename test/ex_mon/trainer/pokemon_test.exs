defmodule ExMon.Trainer.PokemonTest do
  use ExMon.DataCase

  alias ExMon.Trainer.{Pokemon, Create}

  describe "build/1" do
    test "when params is valid, return a pokemon" do
      params = %{"name" => "Adriel", "password" => "123456"}

      {:ok, trainer} = Create.call(params)

      params_pokemon = %{name: "pikachu", types: ["electric"], weight: 60, trainer_id: trainer.id, nickname: "chu"}

      response = Pokemon.build(params_pokemon)

      assert {:ok, %Pokemon{name: "pikachu", nickname: "chu", types: ["electric"], weight: 60 }} = response
    end

    test "when params is invalid, return a error" do
      params = %{"name" => "Adriel", "password" => "123456"}

      {:ok, trainer} = Create.call(params)

      params_pokemon = %{name: "pikachu", types: ["electric"], weight: 60, trainer_id: trainer.id, nickname: "c"}

      {:error, changeset} = Pokemon.build(params_pokemon)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{nickname: ["should be at least 2 character(s)"]}
    end
  end

  describe "update_changeset/2" do
    test "when update pokemon, return a changed pokemon" do
      params = %{"name" => "Adriel", "password" => "123456"}

      {:ok, trainer} = Create.call(params)

      params_pokemon = %{name: "pikachu", types: ["electric"], weight: 60, trainer_id: trainer.id, nickname: "chu"}

      {:ok, pokemon} = Pokemon.build(params_pokemon)

      params_pokemon_update = %{nickname: "chus"}

      response = Pokemon.update_changeset(pokemon, params_pokemon_update)

      assert %Ecto.Changeset{changes: %{nickname: "chus"}, data: %ExMon.Trainer.Pokemon{}, valid?: true} = response
    end

    test "when update pokemon with a error, return a error" do
      params = %{"name" => "Adriel", "password" => "123456"}

      {:ok, trainer} = Create.call(params)

      params_pokemon = %{name: "pikachu", types: ["electric"], weight: 60, trainer_id: trainer.id, nickname: "chu"}

      {:ok, pokemon} = Pokemon.build(params_pokemon)

      params_pokemon_update = %{nickname: "c"}

      response = Pokemon.update_changeset(pokemon, params_pokemon_update)

      assert %Ecto.Changeset{valid?: false} = response
      assert errors_on(response) == %{nickname: ["should be at least 2 character(s)"]}
    end
  end
end
