defmodule ExMon.Trainer.Pokemon.GetTest do
  use ExMon.DataCase

  import Tesla.Mock

  alias ExMon.Trainer.Pokemon.{Create, Get}
  alias ExMon.Trainer.Create, as: CreateTrainer

  @base_url "https://pokeapi.co/api/v2/pokemon"

  describe "call/1" do
    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, trainer} = CreateTrainer.call(params)

      types = [
        %{
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]
      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{"name" => "pikachu", "nickname" => "chuu", "trainer_id" => trainer.id}

      {:ok, pokemon} = Create.call(pokemon_params)

      {:ok, pokemon: pokemon}
    end

    test "when id is valid, return the pokemon", pokemon do
      {:ok, response} = Get.call(pokemon[:pokemon].id)

      assert %ExMon.Trainer.Pokemon{id: _id, inserted_at: _inserted_at, name: "pikachu", nickname: "chuu", trainer_id: _trainer_id, types: ["electric"], updated_at: _updated_at, weight: 60} = response
    end

    test "when id is invalid, return a error" do
      {:error, response} = Get.call("12345")

      assert response == %{message: "Invalid ID format!", status: 400}
    end

    test "when id is valid, but not found in data base, return a error" do
      {:error, response} = Get.call(Ecto.UUID.generate())

      assert response == %{message: "Pokemon not found", status: 404}
    end
  end
end
