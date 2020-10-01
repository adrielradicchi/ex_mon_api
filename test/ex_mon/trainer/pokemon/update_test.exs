defmodule ExMon.Trainer.Pokemon.UpdateTest do
  use ExMon.DataCase

  import Tesla.Mock

  alias ExMon.Trainer.Pokemon.{Create, Update}
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
      params = %{"id" => pokemon[:pokemon].id, "nickname" => "chu"}
      {:ok, response} = Update.call(params)

      assert response.id == pokemon[:pokemon].id
      assert response.inserted_at == pokemon[:pokemon].inserted_at
    end

    test "when nickname is invalid, return a error", pokemon do
      params = %{"id" => pokemon[:pokemon].id, "nickname" => "c"}
      {:error, response} = Update.call(params)

      assert %Ecto.Changeset{valid?: false} = response
      assert errors_on(response) == %{nickname: ["should be at least 2 character(s)"]}
    end

    test "when id is format invalid, return the error" do
      params = %{"id" => "1234", "nickname" => "chu" }
      response = Update.call(params)

      assert response == {:error, %{message: "Invalid ID format!", status: 400}}
    end

    test "when id is format valid but pokemon is not found, return the error" do
      params = %{"id" => Ecto.UUID.generate(), "nickname" => "chu" }
      response = Update.call(params)

      assert response == {:error, %{message: "Pokemon not found", status: 404}}
    end
  end
end
