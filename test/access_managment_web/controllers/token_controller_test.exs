defmodule AccessManagmentWeb.TokenControllerTest do
  alias AccessManagment.Session.Token
  use AccessManagmentWeb.ConnCase

  import AccessManagment.AccessFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create token" do
    setup [:create_user]

    test "renders token when valid email/password params", %{
      conn: conn,
      user: %{id: id, email: email, password: password}
    } do
      conn = post(conn, ~p"/api/auth", %{"email" => email, "password" => password})
      assert %{"token" => token} = json_response(conn, 201)

      assert {:ok, %{"id" => ^id, "email" => ^email}} = Token.verify_and_validate(token)
    end
  end

  defp create_user(_) do
    password = "Pass@1234567"
    %{id: id, email: email} = user_fixture(%{password: password})
    %{user: %{id: id, email: email, password: password}}
  end
end
