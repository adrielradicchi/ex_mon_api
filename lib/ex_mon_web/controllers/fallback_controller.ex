defmodule ExMonWeb.FallbackController do
  use ExMonWeb, :controller

  def call(conn, {:error, %{status: 400} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonWeb.ErrorView)
    |> render("400.json", result: result) # fazer um mapa de todos os status e redenrizar a pagina certa de cada erro
  end

  def call(conn, {:error, %{status: 401} = result}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExMonWeb.ErrorView)
    |> render("401.json", result: result) # fazer um mapa de todos os status e redenrizar a pagina certa de cada erro
  end

  def call(conn, {:error, %{status: 404} = result}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExMonWeb.ErrorView)
    |> render("404.json", result: result) # fazer um mapa de todos os status e redenrizar a pagina certa de cada erro
  end

  def call(conn, {:error, %{status: 500} = result}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(ExMonWeb.ErrorView)
    |> render("500.json", result: result) # fazer um mapa de todos os status e redenrizar a pagina certa de cada erro
  end

  def call(conn, {:error, %Ecto.Changeset{} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonWeb.ErrorView)
    |> render("400.json", result: result) # fazer um mapa de todos os status e redenrizar a pagina certa de cada erro
  end
end
