defmodule ExMonWeb.WelcomeController do
  use ExMonWeb, :controller

  def index(conn, _param) do
    text(conn, "Welcome to the ExMon API!")
  end
end
