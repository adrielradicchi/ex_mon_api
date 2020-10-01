defmodule ExMon.Trainer.CreateTest do
  use ExMon.DataCase

  alias ExMon.{Trainer, Repo}
  alias Trainer.Create

  describe "call/1" do
    test "when all params are valid, creates a trainer" do
      params = %{name: "Adriel", password: "123456"}

      count_before = Repo.aggregate(Trainer, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{name: "Adriel"}} = response
      assert count_after > count_before
    end

    test "when all params are invalid, return the error" do
      params = %{name: "Adriel"}

      response = Create.call(params)

      assert {:error, changeset} = response
      assert errors_on(changeset) == %{password: ["can't be blank"]}
    end
  end
end
