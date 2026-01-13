defmodule CriptOro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CriptOroWeb.Telemetry,
      # CriptOro.Repo,
      {DNSCluster, query: Application.get_env(:cript_oro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CriptOro.PubSub},

      CriptOro.Workers.PriceWorker,
      CriptOro.Workers.CurrencyWorker,

      # Start to serve requests, typically the last entry
      CriptOroWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CriptOro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CriptOroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
