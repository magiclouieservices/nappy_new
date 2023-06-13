import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/nappy start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :nappy, NappyWeb.Endpoint, server: true
end

config :ex_azure_vision,
  header_name: System.get_env("AZURE_OCP_APIM_HEADER_NAME"),
  subscription_key: System.get_env("AZURE_OCP_APIM_SUBSCRIPTION_KEY"),
  base_url: System.get_env("AZURE_COGNITIVE_VISION_BASE_URI"),
  scheme: "https"

config :nappy, :runtime,
  app_name: "Nappy",
  getty_api_key: System.get_env("GETTY_API_KEY"),
  getty_api_secret: System.get_env("GETTY_API_SECRET"),
  support_email: "support@nappy.co",
  notifications_email: "notifications@nappy.co",
  image_src_host: System.get_env("IMAGE_SRC", "devnappy.imgix.net"),
  nappy_host: System.get_env("NAPPY_DOMAIN", "dev.nappy.co"),
  embed_host: System.get_env("NAPPY_EMBED_DOMAIN", "src-staging.nappy.co"),
  subscription_host: System.get_env("SUBSCRIPTION_HOST"),
  sendy_api_key: System.get_env("SENDY_API_KEY"),
  sendy_members_list: System.get_env("SENDY_MEMBERS_LIST"),
  sendy_photographers_list: System.get_env("SENDY_PHOTOGRAPHERS_LIST"),
  sendy_webform_list: System.get_env("SENDY_WEBFORM_LIST"),
  twitter_handle: System.get_env("TWITTER_HANDLE"),
  twitter_site_id: System.get_env("TWITTER_SITE_ID"),
  facebook_app_id: System.get_env("FACEBOOK_APP_ID")

config :ex_aws, :s3,
  access_key_id: System.get_env("WASABI_ACCESS_KEY_ID", "minio-root-user"),
  secret_access_key: System.get_env("WASABI_SECRET_ACCESS_KEY", "minio-root-password"),
  region: System.get_env("WASABI_REGION", "us-east-1"),
  bucket_name: System.get_env("BUCKET_NAME", "nappy"),
  scheme: System.get_env("WASABI_SCHEME", "http://"),
  host: System.get_env("WASABI_HOST", "localhost")

if config_env() == :prod do
  config :honeybadger,
    exclude_envs: [:test],
    environment_name: :prod,
    use_logger: true,
    api_key: System.get_env("HONEYBADGER_API_KEY")

  config :logger,
    # or other Logger level
    level: :info,
    backends: [LogflareLogger.HttpBackend]

  config :logflare_logger_backend,
    url: System.get_env("LOGFLARE_URL"),
    # Default LogflareLogger level is :info. Note that log messages are filtered by the :logger application first
    level: :info,
    api_key: System.get_env("LOGFLARE_API_KEY"),
    source_id: System.get_env("LOGFLARE_SOURCE_ID"),
    # minimum time in ms before a log batch is sent
    flush_interval: 1_000,
    # maximum number of events before a log batch is sent
    max_batch_size: 50,
    metadata: :all

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :nappy, Nappy.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :nappy, NappyWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  config :nappy, Nappy.Mailer,
    adapter: Swoosh.Adapters.Mailgun,
    api_key: System.get_env("MAILGUN_API_KEY"),
    domain: System.get_env("MAILGUN_DOMAIN"),
    base_url: System.get_env("MAILER_BASE_URL")

  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  config :swoosh, :api_client, Swoosh.ApiClient.Finch
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
