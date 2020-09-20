defmodule ExMonWeb.FallbackController do
  use ExMonWeb, :controller

  def call(conn, {:error, %{status: status} = result}) do
    conn
    |> put_status(status)
    |> put_view(ExMonWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(conn, {:error, %Ecto.Changeset{} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
