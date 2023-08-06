defmodule AccessManagment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AccessManagmentWeb.Telemetry,
      # Start the Ecto repository
      AccessManagment.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AccessManagment.PubSub},
      # Start Finch
      {Finch, name: AccessManagment.Finch},
      # Start the Endpoint (http/https)
      AccessManagmentWeb.Endpoint
      # Start a worker by calling: AccessManagment.Worker.start_link(arg)
      # {AccessManagment.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AccessManagment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AccessManagmentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
