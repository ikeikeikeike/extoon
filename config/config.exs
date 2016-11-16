# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :extoon,
  ecto_repos: [Extoon.Repo]

# Configures the endpoint
config :extoon, Extoon.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T/ba55E0Om1HHZfZITcjOK0X+EOtuLy4PXkwOu0IU26GLRwLp2bRLRCv7EC1gSVL",
  render_errors: [view: Extoon.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Extoon.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ua_inspector,
  database_path: Path.join(File.cwd!, "config/ua_inspector")

config :exsentry,
  otp_app: :extoon,
  dsn: ""

config :esx, ESx.Model,
  repo: Extoon.Repo,
  protocol: "http",
  host: "localhost",
  port: 9200

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "consts.secret.exs"
