defmodule AccessManagment.PermissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AccessManagment.Permissions` context.
  """

  @doc """
  Generate a unique permission title.
  """
  def unique_permission_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: unique_permission_title()
      })
      |> AccessManagment.Permissions.create_permission()

    permission
  end
end
