use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :extoon, Extoon.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :extoon, Extoon.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :logger,
  level: :debug,
  backends: [
    :console,
    {ExSyslog, :exsyslog_error},
    {ExSyslog, :exsyslog_debug},
    {ExSyslog, :exsyslog_json}
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :extoon, Extoon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "extoon_dev",
  hostname: "localhost",
  pool_size: 10

config :esx, ESx.Model,
  repo: Extoon.Repo,
  protocol: "http",
  host: "127.0.0.1",
  port: 9200,
  trace: true

config :extoon, :google_verify,
  "noname"

import_config "dev.secret.exs"
