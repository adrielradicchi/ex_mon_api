# defmodule ExMonWeb.WelcomeControllerTest do
#   use ExMon.ConnCase

#   alias ExMon.Trainer.Pokemon

#   describe "index/2" do
#     test "when open  index a trainer valid, return the trainer", %{conn: conn} do
#       params = %{name: "Adriel", password: "123456"}

#       response =
#         conn
#         |> post(Routes.trainers_path(conn, :create, params))
#         |> json_response(:created)

#       assert %{"message" => "Trainer created!", "trainer" => %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adriel"}} = response
#     end
#   end
# end
