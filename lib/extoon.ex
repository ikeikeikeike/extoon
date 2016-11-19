defmodule Extoon do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Extoon.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Extoon.Endpoint, []),
      # Start your own worker by calling: Extoon.Worker.start_link(arg1, arg2, arg3)
      # worker(Extoon.Worker, [arg1, arg2, arg3]),
      worker(ConCache, [[ttl_check: :timer.seconds(60), ttl: :timer.seconds(60 * 10)], [name: :new_entries]], id: :extoon_new_entries_cache),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Extoon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Extoon.Endpoint.config_change(changed, removed)
    :ok
  end
end
