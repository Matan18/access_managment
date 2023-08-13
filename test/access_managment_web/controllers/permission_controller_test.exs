defmodule AccessManagmentWeb.PermissionControllerTest do
  use AccessManagmentWeb.ConnCase

  import AccessManagment.PermissionsFixtures
  import AccessManagment.AccessFixtures
  import AccessManagment.Session

  alias AccessManagment.Permissions.Permission

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_token_setup]

    test "lists all permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create permission" do
    setup [:create_token_setup]

    test "renders permission when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/permissions", permission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/permissions/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/permissions", permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update permission" do
    setup [:create_permission]
    setup [:create_token_setup]

    test "renders permission when data is valid", %{
      conn: conn,
      permission: %Permission{id: id} = permission
    } do
      conn = put(conn, ~p"/api/permissions/#{permission}", permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/permissions/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, permission: permission} do
      conn = put(conn, ~p"/api/permissions/#{permission}", permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete permission" do
    setup [:create_permission]
    setup [:create_token_setup]

    test "deletes chosen permission", %{conn: conn, permission: permission} do
      conn = delete(conn, ~p"/api/permissions/#{permission}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/permissions/#{permission}")
      end
    end
  end

  defp create_token_setup(%{conn: conn}) do
    password = "Senha@123456"
    %{email: email} = user_fixture(%{password: password})

    {:ok, token, _} = create_token(%{"email" => email, "password" => password})

    conn =
      conn
      |> put_req_header("authorization", token)

    %{conn: conn}
  end

  defp create_permission(_) do
    permission = permission_fixture()

    %{permission: permission}
  end
end
