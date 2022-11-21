defmodule Clickme.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ClickmeWeb.Telemetry,
      # Start the Ecto repository
      Clickme.Repo,
      Clickme.Counter,
      # Start the PubSub system
      {Phoenix.PubSub, name: Clickme.PubSub},
      # Start the Endpoint (http/https)
      ClickmeWeb.Endpoint
      # Start a worker by calling: Clickme.Worker.start_link(arg)
      # {Clickme.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clickme.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClickmeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
