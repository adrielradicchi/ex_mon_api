defmodule ExMon.Trainer.Pokemon.CreateTest do
  use ExMon.DataCase
  import Tesla.Mock

  alias ExMon.Trainer.{Pokemon.Create}
  alias ExMon.Trainer.Create, as: CreateTrainer

  @base_url "https://pokeapi.co/api/v2/pokemon"

  describe "call/1" do
    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, trainer} = CreateTrainer.call(params)

      {:ok, trainer: trainer}
    end

    test "when all params are valid, creates a pokemon", trainer do
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

      pokemon_params = %{"name" => "pikachu", "nickname" => "chuu", "trainer_id" => trainer[:trainer].id}

      {:ok, response} = Create.call(pokemon_params)
      assert %ExMon.Trainer.Pokemon{name: "pikachu", nickname: "chuu", types: ["electric"], weight: 60} = response
    end

    test "when nickname param is invalid, return the error", trainer do
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

      pokemon_params = %{"name" => "pikachu", "nickname" => "c", "trainer_id" => trainer[:trainer].id}

      {:error, response} = Create.call(pokemon_params)
      assert %Ecto.Changeset{valid?: false} = response
      assert errors_on(response) == %{nickname: ["should be at least 2 character(s)"]}
    end

    test "when trainer id param is invalid, return the error" do
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

      pokemon_params = %{"name" => "pikachu", "nickname" => "c", "trainer_id" => "1234"}

      {:error, response} = Create.call(pokemon_params)
      assert response == %{message: "Invalid ID format!", status: 400}
    end

    test "when trainer id param is valid and not found in data base, return the error" do
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

      pokemon_params = %{"name" => "pikachu", "nickname" => "c", "trainer_id" => Ecto.UUID.generate()}

      {:error, response} = Create.call(pokemon_params)
      assert response == %{message: "Trainer not found", status: 404}
    end
  end
end
