defmodule ExMon.Trainer.UpdateTest do
  use ExMon.DataCase

  alias ExMon.Trainer.{Create, Update}

  describe "call/1" do
    setup do
      params = %{name: "Adriel", password: "123456"}
      {:ok, trainer} = Create.call(params)

      {:ok, trainer: trainer}
    end

    test "when id is valid, return the trainer", trainer do
      params = %{"id" => trainer[:trainer].id, "name" => "Joaquim", "password" => "987654" }
      {:ok, response} = Update.call(params)

      assert response.id == trainer[:trainer].id
      assert response.inserted_at == trainer[:trainer].inserted_at
    end

    test "when id is format invalid, return the error" do
      params = %{"id" => "1234", "name" => "Joaquim", "password" => "987654" }
      response = Update.call(params)

      assert response == {:error, %{message: "Invalid ID format!", status: 400}}
    end

    test "when id is format valid but trainer is not found, return the error" do
      params = %{"id" => Ecto.UUID.generate(), "name" => "Joaquim", "password" => "987654" }
      response = Update.call(params)

      assert response == {:error, %{message: "Trainer not found", status: 404}}
    end
  end
end
