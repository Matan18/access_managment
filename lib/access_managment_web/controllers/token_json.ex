defmodule AccessManagmentWeb.TokenJSON do
  @doc """
  Renders a single token.
  """
  def show(%{token: token}) do
    %{token: token}
  end
end
