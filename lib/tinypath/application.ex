defmodule Tinypath.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TinypathWeb.Telemetry,
      Tinypath.Repo,
      {DNSCluster, query: Application.get_env(:tinypath, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tinypath.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tinypath.Finch},
      # Start a worker by calling: Tinypath.Worker.start_link(arg)
      # {Tinypath.Worker, arg},
      # Start to serve requests, typically the last entry
      TinypathWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tinypath.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TinypathWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
