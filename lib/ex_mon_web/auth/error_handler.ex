defmodule ExMonWeb.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {:invalid_token, _reason}, _opts),
    do: response(conn, :unauthorized, %{message: "Invalid Token", status: 401})

  def auth_error(conn, {:unauthenticated, _reason}, _opts),
    do: response(conn, :unauthorized, %{message: "Not Authenticated", status: 401})

  def auth_error(conn, {:no_resource_found, _reason}, _opts),
    do: response(conn, :unauthorized,  %{message: "No Resource Found", status: 401})

  def auth_error(conn, {type, _reason}, _opts), do: response(conn, :forbidden, %{message: to_string(type), status: 403})

  defp response(conn, status, message) do
    body = Jason.encode!(%{error: message})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
