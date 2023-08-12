defmodule AccessManagmentWeb.Plugs.Auth do
  import Plug.Conn

  alias AccessManagment.Session

  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    [token] = get_req_header(conn, "authorization")

    Session.validate_token(%{token: token})
    |> handle_token(conn)
  end

  defp handle_token(true, conn), do: conn

  defp handle_token(false, conn) do
    conn
    |> Plug.Conn.resp(403, "Unauthorized")
    |> Plug.Conn.send_resp()
  end
end
