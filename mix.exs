defmodule Nappy.MixProject do
  use Mix.Project

  def project do
    [
      app: :nappy,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Nappy.Application, []},
      extra_applications: [:logger, :runtime_tools, :honeybadger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.6.15"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.8"},
      {:ecto_psql_extras, "~> 0.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.4.0", only: :dev},
      {:phoenix_live_view, "~> 0.18.9"},
      {:floki, ">= 0.34.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.7"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.3"},
      {:plug_cowboy, "~> 2.6"},
      {:finch, "~> 0.13"},
      {:tailwind, "~> 0.1.9", runtime: Mix.env() == :dev},
      {:sobelow, "~> 0.11", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ecto_dev_logger, "~> 0.7"},
      {:image, "~> 0.22"},
      {:scrivener_ecto, "~> 2.7"},
      {:ex_aws, "~> 2.3"},
      {:ex_aws_s3, "~> 2.4"},
      {:hackney, "~> 1.18"},
      {:sweet_xml, "~> 0.7.3"},
      {:honeybadger, "~> 0.19.0"},
      {:req, "~> 0.3.1"},
      {:cachex, "~> 3.5"},
      {:mox, "~> 1.0", only: :test},
      {:logflare_logger_backend, "~> 0.11.0"},
      {:wallaby, "~> 0.30.1", only: :test, runtime: false},
      {:oban, "~> 2.13"},
      {:ex_azure_vision, "~> 0.1.2"},
      {:nanoid, "~> 2.0.5"},
      {:carbonite, "~> 0.9.0"},
      {:phoenix_seo, "~> 0.1.8"},
      {:ex_typesense, path: "/Users/jaeyson/Documents/Github/ex_typesense"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
