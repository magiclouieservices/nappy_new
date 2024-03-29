# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :nappy,
  ecto_repos: [Nappy.Repo]

# Configures the endpoint
config :nappy, NappyWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    view: NappyWeb.ErrorView,
    accepts: ~w(html json),
    root_layout: {NappyWeb.ErrorView, "root.html"},
    layout: false
  ],
  pubsub_server: Nappy.PubSub,
  live_view: [signing_salt: "qK3SHwn/"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :nappy, Nappy.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args: ~w(
      js/app.js
      fonts/tiempos.css
      fonts/solid.min.css
      fonts/fontawesome.min.css
      fonts/brands.min.css
      fonts/regular.min.css
      --bundle
      --loader:.woff=file
      --loader:.woff2=file
      --loader:.ttf=file
      --loader:.eot=file
      --loader:.svg=file
      --target=es2017
      --outdir=../priv/static/assets
      --external:/fonts/*
      --external:/images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
