defmodule AccessManagmentWeb.Router do
  use AccessManagmentWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :accepts, ["json"]
    plug AccessManagmentWeb.Plugs.Auth
  end

  scope "/api", AccessManagmentWeb do
    pipe_through :api

    post "/auth", TokenController, :create

    resources "/users", UserController, only: [:create, :index, :show]
  end

  scope "/api", AccessManagmentWeb do
    pipe_through :auth

    resources "/users", UserController, only: [:update, :delete]
    resources "/permissions", PermissionController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:access_managment, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AccessManagmentWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
