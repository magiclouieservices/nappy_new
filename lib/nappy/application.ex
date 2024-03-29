defmodule Nappy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # (Dev only): alternative logger for Ecto queries
    # Ecto.DevLogger.install(Nappy.Repo)

    children = [
      # Start the Ecto repository
      Nappy.Repo,
      # Start the Telemetry supervisor
      NappyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Nappy.PubSub},
      # Start the Endpoint (http/https)
      NappyWeb.Endpoint,
      # Start a worker by calling: Nappy.Worker.start_link(arg)
      # {Nappy.Worker, arg}
      # Finch for swoosh api client
      {Finch, name: Swoosh.Finch},

      # caching response
      {Cachex, name: :nappy_cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nappy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NappyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
