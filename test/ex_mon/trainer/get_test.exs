defmodule ExMon.Trainer.GetTest do
  use ExMon.DataCase

  alias ExMon.{Trainer.Create, Trainer.Get}

  describe "call/1" do
    setup do
      params = %{name: "Adriel", password: "123456"}
      {:ok, trainer} = Create.call(params)

      {:ok, trainer: trainer}
    end

    test "when id is valid, return the trainer", trainer do

      {:ok, response} = Get.call(trainer[:trainer].id)

      assert response.id == trainer[:trainer].id
      assert response.name == trainer[:trainer].name
    end

    test "when id is format invalid, return the error" do
      response = Get.call("1234")

      assert response == {:error, %{message: "Invalid ID format!", status: 400}}
    end

    test "when id is format valid but trainer is not found, return the error" do
      response = Get.call(Ecto.UUID.generate())

      assert response == {:error, %{message: "Trainer not found", status: 404}}
    end
  end
end
