defmodule Extoon.Mixfile do
  use Mix.Project

  def project do
    [app: :extoon,
     version: version(),
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  defp version do
    v = "0.5.6"
    File.write! "VERSION", v
    v
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Extoon, []},
     applications: [
       :phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
       :phoenix_ecto, :postgrex,

       :httpoison,

       :arc_ecto,
       :ex_aws,
       :hackney,
       :poison,

       :exsentry,
       :quantum,
       :rdtype,
       :common_device_detector,

       :floki,
       :the_fuzz,
       :phoenix_html_simplified_helpers,

       :floki,
       :mochiweb,
       :html_sanitize_ex,
       :html_entities,

       :con_cache,

       :esx,
       :scrivener_esx,
       :scrivener_ecto,
       :scrivener_html,

       :arc,
       :exactor,
       :exjsx,
       :jsx,
       :sweet_xml,
       :timex_ecto,

       :sitemap,
       :bamboo,

       :distillery,
     ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},

      {:httpoison, "~> 0.9"},

      # arcs
      {:arc, "~> 0.6.0-rc3"},
      {:arc_ecto, "~> 0.5.0-rc1"},
      {:ex_aws, "~> 1.0.0-rc3"},
      {:hackney, "~> 1.5"},
      {:poison, "~> 2.0"},
      {:sweet_xml, "~> 0.5"},
      {:yamerl, "~> 0.3", override: true},
      {:quantum, "~> 1.7"},
      {:rdtype, github: "ikeikeikeike/rdtype"},
      {:common_device_detector, github: "ikeikeikeike/common_device_detector"},
      {:exsentry, "~> 0.7"},
      {:floki, "~> 0.11"},
      {:the_fuzz, "~> 0.3"},
      {:phoenix_html_simplified_helpers, "~> 0.7"},
      {:html_entities, "~> 0.3"},
      {:html_sanitize_ex, "~> 1.1"},
      {:floki, "~> 0.11"},
      {:mochiweb, ">= 2.12.2", override: true},
      {:con_cache, "~> 0.11"},
      {:esx, "~> 0.2"},
      {:scrivener_esx, "~> 0.2"},
      {:scrivener_ecto, "~> 1.0"},
      {:scrivener_html, "~> 1.1"},
      {:distillery, "~> 1.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:sitemap, ">= 0.0.0"},
      {:bamboo, "~> 0.8"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
