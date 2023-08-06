defmodule AccessManagment.AccessTest do
  use AccessManagment.DataCase

  alias AccessManagment.Access

  describe "users" do
    alias AccessManagment.Access.User

    import AccessManagment.AccessFixtures

    @invalid_attrs %{email: nil, name: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Access.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Access.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some@email.com", name: "some name", password: "Some_password1"}

      assert {:ok, %User{} = user} = Access.create_user(valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Access.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "some_updated@email.com",
        name: "some updated name",
        password: "Some_updated_password1"
      }

      assert {:ok, %User{} = user} = Access.update_user(user, update_attrs)
      assert user.email == "some_updated@email.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Access.update_user(user, @invalid_attrs)
      assert user == Access.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Access.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Access.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Access.change_user(user)
    end
  end
end
