defmodule AccessManagmentWeb.TokenController do
  use AccessManagmentWeb, :controller

  alias AccessManagment.Session

  action_fallback AccessManagmentWeb.FallbackController

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, token, _} <- Session.create_token(params) do
      conn
      |> put_status(:created)
      |> render(:show, token: token)
    end
  end
end
