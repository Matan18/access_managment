defmodule AccessManagment.AccessFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AccessManagment.Access` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some_email#{System.unique_integer([:positive])}@email.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: "some name",
        password: "Some_password@1"
      })
      |> AccessManagment.Access.create_user()

    user
  end
end
