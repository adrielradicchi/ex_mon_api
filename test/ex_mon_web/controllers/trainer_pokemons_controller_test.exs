defmodule ExMonWeb.TrainerPokemonsControllerTest do
  use ExMonWeb.ConnCase
  import Tesla.Mock

  alias ExMon.{Trainer, Trainer.Pokemon}

  @base_url "https://pokeapi.co/api/v2/pokemon"

  describe "create/2" do

    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      pokemon_types = [
        %{
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]

      {:ok, trainer_id: trainer_id, pokemon_types: pokemon_types}
    end

    test "when create a pokemon valid, return the pokemon", %{conn: conn, trainer_id: trainer_id, pokemon_types: pokemon_types} do

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{name: "pikachu", nickname: "chuu", trainer_id: trainer_id}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, pokemon_params))
        |> json_response(:created)

      # assert %{"message" => "Pokemon created!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"}} = response
      assert %{"Pokemon" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "pikachu", "nickname" => "chuu", "trainer_id" => _trainer_id, "types" => ["electric"], "weight" => 60}, "message" => "Pokemon created!"} = response
    end

    test "when create a pokemon but nickname is invalid, return the error", %{conn: conn, trainer_id: trainer_id, pokemon_types: pokemon_types} do

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{name: "pikachu", nickname: "c", trainer_id: trainer_id}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, pokemon_params))
        |> json_response(:bad_request)

      expected_message = %{"message" => %{"nickname" => ["should be at least 2 character(s)"]}}
      # assert %{"message" => "Pokemon created!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"}} = response
      assert response == expected_message
    end

    test "when create a pokemon valid but trainer id is invalid, return the error", %{conn: conn, pokemon_types: pokemon_types} do

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{name: "pikachu", nickname: "chuu", trainer_id: "1234"}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, pokemon_params))
        |> json_response(:bad_request)

      expected_message = %{"message" => %{"message" => "Invalid ID format!","status" => 400}}
      # assert %{"message" => "Pokemon created!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"}} = response
      assert response == expected_message
    end

    test "when create a pokemon valid, but trainer is not found, return the error", %{conn: conn, pokemon_types: pokemon_types} do

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{name: "pikachu", nickname: "chuu", trainer_id: Ecto.UUID.generate()}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, pokemon_params))
        |> json_response(:not_found)

      expected_message = %{"message" => %{"message" => "Trainer not found","status" => 404}}
      assert response == expected_message
    end
  end

  describe "show/2" do

    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      pokemon_types = [
        %{
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{"name" => "pikachu", "nickname" => "chuu", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMon.create_trainer_pokemon(pokemon_params)

      {:ok, pokemon_id: pokemon_id}
    end

    test "when there is a trainer with given id, return the trainer", %{conn: conn, pokemon_id: pokemon_id} do

      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :show, pokemon_id))
        |> json_response(:ok)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "pikachu", "nickname" => "chuu", "trainer" => %{"id" => _trainer_id, "name" => "Adriel"}, "types" => ["electric"], "weight" => 60} = response
    end

    test "when there is an error, return the error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}

      assert response == expected_response
    end

    test "when there is id formart valid and id not exists, return the error", %{conn: conn} do

      response =
          conn
          |> get(Routes.trainer_pokemons_path(conn, :show, Ecto.UUID.generate()))
          |> json_response(:not_found)

      expected_response = %{"message" => %{"message" => "Pokemon not found", "status" => 404}}

      assert response == expected_response
    end
  end

  describe "delete/2" do

    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      pokemon_types = [
        %{
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{"name" => "pikachu", "nickname" => "chuu", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMon.create_trainer_pokemon(pokemon_params)

      {:ok, pokemon_id: pokemon_id}
    end

    test "when delete a pokemon valid, return no content", %{conn: conn, pokemon_id: pokemon_id} do
      response =
        conn
        |> delete(Routes.trainer_pokemons_path(conn, :delete, pokemon_id))

      assert response.resp_body == ""
      assert response.status == 204
    end

    test "when there is an error, return the error", %{conn: conn} do

      response =
          conn
          |> delete(Routes.trainer_pokemons_path(conn, :delete, "1234"))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}

      assert response == expected_response
    end

    test "when there is id formart valid and id not exists, return the error", %{conn: conn} do

      response =
          conn
          |> delete(Routes.trainer_pokemons_path(conn, :delete, Ecto.UUID.generate()))
          |> json_response(:not_found)

      expected_response = %{"message" => %{"message" => "Pokemon not found", "status" => 404}}

      assert response == expected_response
    end
  end

  describe "update/2" do

    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      pokemon_types = [
        %{
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ]

      body = %{"id" => 25, "name" => "pikachu", "weight" => 60, "types" => pokemon_types}

      mock(fn %{method: :get, url: @base_url <> "/pikachu" } ->
        %Tesla.Env{status: 200, body: body}
      end)

      pokemon_params = %{"name" => "pikachu", "nickname" => "chuu", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: id}} = ExMon.create_trainer_pokemon(pokemon_params)

      {:ok, pokemon_id: id}
    end

    test "when id is valid, return the pokemon", %{conn: conn, pokemon_id: id} do
      params = %{nickname: "pikachu"}

      response =
        conn
        |> put(Routes.trainer_pokemons_path(conn, :update, id, params))
        |> json_response(:ok)

      assert %{"Pokemon" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "pikachu", "nickname" => "pikachu", "trainer_id" => _trainer_id, "types" => ["electric"], "updated_at" => _update_at, "weight" => 60}, "message" => "Pokemon updated!"} = response
    end

    test "when id is valid but the nickname is invalid, return the error", %{conn: conn, pokemon_id: id} do
      params = %{nickname: "p"}

      response =
        conn
        |> put(Routes.trainer_pokemons_path(conn, :update, id, params))
        |> json_response(:bad_request)

      assert response == %{"message" => %{"nickname" => ["should be at least 2 character(s)"]}}
    end

    test "when id is format invalid, return the error", %{conn: conn} do
      params = %{nickname: "pikachu"}

      response =
        conn
        |> put(Routes.trainer_pokemons_path(conn, :update, "1234", params))
        |> json_response(:bad_request)

      assert response == %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}
    end

    test "when id is format valid but pokemon is not found, return the error", %{conn: conn} do
      params = %{nickname: "pikachu"}

      response =
        conn
        |> put(Routes.trainer_pokemons_path(conn, :update, Ecto.UUID.generate(), params))
        |> json_response(:not_found)

      assert response == %{"message" => %{"message" => "Pokemon not found", "status" => 404}}
    end
  end
end
