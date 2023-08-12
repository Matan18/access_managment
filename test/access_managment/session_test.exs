defmodule AccessManagment.SessionTest do
  use AccessManagment.DataCase

  alias Ecto.UUID
  alias AccessManagment.Session
  alias AccessManagment.Session.Token

  import AccessManagment.AccessFixtures

  describe "auth" do
    setup [:create_user]

    test "create_token/1 with valid data creates a token", %{
      user: %{id: id, email: email, password: password}
    } do
      assert {:ok, _token, %{"id" => ^id, "email" => ^email}} =
               Session.create_token(%{"email" => email, "password" => password})
    end

    test "create_token/1 with not registered email returns not_found", _ do
      assert {:error, :not_found} =
               Session.create_token(%{"email" => "not_registered@mail.com", "password" => "pass"})
    end

    test "create_token/1 with not matching password returns not_found", %{
      user: %{email: email}
    } do
      assert {:error, :not_found} =
               Session.create_token(%{"email" => email, "password" => "pass"})
    end

    test "find_and_validate_user/0 return :ok when user is valid", %{
      user: %{id: id, email: email, password: password}
    } do
      assert {:ok, %{id: ^id, email: ^email}} =
               Session.find_and_validate_user(%{"email" => email, "password" => password})
    end

    test "find_and_validate_user/0 return :error when not registered email", _ do
      assert {:error, :not_found} =
               Session.find_and_validate_user(%{
                 "email" => "not_registered@mail.com",
                 "password" => "pass"
               })
    end

    test "find_and_validate_user/0 return :error when not matching password", %{
      user: %{email: email}
    } do
      assert {:error, :not_found} =
               Session.find_and_validate_user(%{
                 "email" => email,
                 "password" => "pass"
               })
    end

    test "validate_token!/1 returns true when the token is valid", %{
      user: %{email: email, password: password}
    } do
      assert {:ok, token, _} = Session.create_token(%{"email" => email, "password" => password})
      assert true == Session.validate_token(%{token: token})
    end

    test "validate_token!/1 returns false when the token from not registered email", _ do
      {:ok, token, _} =
        Token.generate_and_sign(%{
          "id" => UUID.generate(),
          "email" => "not_registered@mail.com"
        })

      assert false == Session.validate_token(%{token: token})
    end
  end

  defp create_user(_) do
    password = "Pass@1234567"
    %{id: id, email: email} = user_fixture(%{password: password})
    %{user: %{id: id, email: email, password: password}}
  end
end
