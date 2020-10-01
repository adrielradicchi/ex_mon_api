defmodule ExMon.PokemonTest do
  use ExMon.DataCase

  alias ExMon.Pokemon

  describe "build/1" do
    test "when create struct the pokemon, return the pokemon" do
      types = [
        %{
          "slot" => 1,
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]
      params = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => types}

      response = Pokemon.build(params)

      assert response == %ExMon.Pokemon{id: 25, name: "pikachu", types: ["electric"], weight: 60}
    end
  end
end
