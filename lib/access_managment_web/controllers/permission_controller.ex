defmodule AccessManagmentWeb.PermissionController do
  use AccessManagmentWeb, :controller

  alias AccessManagment.Permissions
  alias AccessManagment.Permissions.Permission

  action_fallback AccessManagmentWeb.FallbackController

  def index(conn, _params) do
    permissions = Permissions.list_permissions()
    render(conn, :index, permissions: permissions)
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, %Permission{} = permission} <- Permissions.create_permission(permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/permissions/#{permission}")
      |> render(:show, permission: permission)
    end
  end

  def show(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)
    render(conn, :show, permission: permission)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{} = permission} <-
           Permissions.update_permission(permission, permission_params) do
      render(conn, :show, permission: permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{}} <- Permissions.delete_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
