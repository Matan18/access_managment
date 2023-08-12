defmodule AccessManagment.Session do
  @moduledoc """
  The Session context.
  """
  use Ecto.Schema

  import Ecto.Query, warn: false
  alias Bcrypt
  alias AccessManagment.Access.User
  alias AccessManagment.Repo
  alias AccessManagment.Access
  alias AccessManagment.Session.Token

  @doc """
  Check email/password and return a jwt

  ## Examples
      iex> %{"email" => "john@sample.com", "password" => "Pass@1234"}
      iex> |> create_token()
      {:ok, "<jwt user token>", claims}

  """
  def create_token(params) do
    params
    |> find_and_validate_user()
    |> gen_token()
  end

  def find_and_validate_user(%{"email" => email, "password" => password}) do
    with %{id: id, email: email, password: hashed_password} <- Access.user_by_email(email),
         true <- Bcrypt.verify_pass(password, hashed_password) do
      {:ok, %{id: id, email: email}}
    else
      _ -> {:error, :not_found}
    end
  end

  @spec validate_token(%{:token => binary, optional(any) => any}) :: any
  def validate_token(%{token: token}) do
    Token.verify_and_validate(token)
    |> handle_validate_token()
  end

  defp gen_token({:ok, %{id: id, email: email}}),
    do: Token.generate_and_sign(%{"id" => id, "email" => email})

  defp gen_token({:error, reason}), do: {:error, reason}

  defp handle_validate_token({:ok, %{"id" => id, "email" => email}}) do
    query =
      from u in User,
        where:
          u.email == ^email and
            u.id == ^id

    Repo.exists?(query)
  end

  defp handle_validate_token({:error, _}), do: false
end
