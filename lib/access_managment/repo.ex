defmodule AccessManagment.Repo do
  use Ecto.Repo,
    otp_app: :access_managment,
    adapter: Ecto.Adapters.Postgres
end
