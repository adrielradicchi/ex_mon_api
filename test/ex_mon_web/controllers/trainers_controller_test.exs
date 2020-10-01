defmodule ExMonWeb.TrainersControllerTest do
  use ExMonWeb.ConnCase

  alias ExMon.Trainer

  describe "create/2" do
    test "when create a trainer valid, return the trainer", %{conn: conn} do
      params = %{name: "Adriel", password: "123456"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(:created)

      assert %{"message" => "Trainer created!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"}} = response
    end

    test "when there is an error, return the error", %{conn: conn} do
      params = %{name: "Adriel"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"password" => ["can't be blank"]}}

      assert response == expected_response
    end
  end

  describe "show/2" do
    test "when there is a trainer with given id, return the trainer", %{conn: conn} do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      response =
        conn
        |> get(Routes.trainers_path(conn, :show, id))
        |> json_response(:ok)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"} = response

    end

    test "when there is an error, return the error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}

      assert response == expected_response
    end

    test "when there is id formart valid and id not exists, return the error", %{conn: conn} do

      response =
          conn
          |> get(Routes.trainers_path(conn, :show, Ecto.UUID.generate()))
          |> json_response(:not_found)

      expected_response = %{"message" => %{"message" => "Trainer not found", "status" => 404}}

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when delete a trainer valid, return no content", %{conn: conn} do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      response =
        conn
        |> delete(Routes.trainers_path(conn, :delete, id))

      assert response.resp_body == ""
      assert response.status == 204
    end

    test "when there is an error, return the error", %{conn: conn} do

      response =
          conn
          |> delete(Routes.trainers_path(conn, :delete, "1234"))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}

      assert response == expected_response
    end

    test "when there is id formart valid and id not exists, return the error", %{conn: conn} do

      response =
          conn
          |> delete(Routes.trainers_path(conn, :delete, Ecto.UUID.generate()))
          |> json_response(:not_found)

      expected_response = %{"message" => %{"message" => "Trainer not found", "status" => 404}}

      assert response == expected_response
    end
  end

  describe "update/2" do

    setup do
      params = %{name: "Adriel", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      {:ok, trainer_id: id}
    end

    test "when id is valid, return the trainer", %{conn: conn, trainer_id: id} do
      params = %{name: "João", password: "123456"}

      response =
        conn
        |> put(Routes.trainers_path(conn, :update, id, params))
        |> json_response(:ok)

      assert %{"message" => "Trainer updated!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "João", "updated_at" => _updated_at}} = response
    end

    test "when id is valid but the password is invalid, return the error", %{conn: conn, trainer_id: id} do
      params = %{password: "12345"}

      response =
        conn
        |> put(Routes.trainers_path(conn, :update, id, params))
        |> json_response(:bad_request)

      assert response == %{"message" => %{"password" => ["should be at least 6 character(s)"]}}
    end

    test "when id is format invalid, return the error", %{conn: conn} do
      params = %{name: "João", password: "123456"}

      response =
        conn
        |> put(Routes.trainers_path(conn, :update, "1234", params))
        |> json_response(:bad_request)

      assert response == %{"message" => %{"message" => "Invalid ID format!", "status" => 400}}
    end

    test "when id is format valid but trainer is not found, return the error", %{conn: conn} do
      params = %{name: "João", password: "123456"}

      response =
        conn
        |> put(Routes.trainers_path(conn, :update, Ecto.UUID.generate(), params))
        |> json_response(:not_found)

      assert response == %{"message" => %{"message" => "Trainer not found", "status" => 404}}
    end
  end
end
