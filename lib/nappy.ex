defmodule Nappy do
  alias Nappy.Admin.Slug

  @moduledoc """
  Nappy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def default_title_suffix, do: " | Beautifully Diverse Stock Photos"
  def app_name, do: Application.get_env(:nappy, :runtime)[:app_name]
  def image_src_host, do: Application.get_env(:nappy, :runtime)[:image_src_host]
  def nappy_host, do: Application.get_env(:nappy, :runtime)[:nappy_host]
  def embed_host, do: Application.get_env(:nappy, :runtime)[:embed_host]
  def getty_api_key, do: Application.get_env(:nappy, :runtime)[:getty_api_key]
  def getty_api_secret, do: Application.get_env(:nappy, :runtime)[:getty_api_secret]
  def notifications_email, do: Application.get_env(:nappy, :runtime)[:notifications_email]
  def support_email, do: Application.get_env(:nappy, :runtime)[:support_email]
  def sendy_api_key, do: Application.get_env(:nappy, :runtime)[:sendy_api_key]
  def sendy_members_list, do: Application.get_env(:nappy, :runtime)[:sendy_members_list]
  def sendy_webform_list, do: Application.get_env(:nappy, :runtime)[:sendy_webform_list]

  def sendy_photographers_list,
    do: Application.get_env(:nappy, :runtime)[:sendy_photographers_list]

  def bucket_name, do: Application.get_env(:ex_aws, :s3)[:bucket_name]

  def subscription_url(path) do
    host = Application.get_env(:nappy, :runtime)[:subscription_host]

    %URI{
      host: host,
      path: Path.join(["/", path]),
      scheme: "https"
    }
    |> URI.to_string()
  end

  def cache_name, do: :nappy_cache

  def get_root_path(conn) do
    URI.parse(Phoenix.Controller.current_path(conn)).path
  end

  def slug_link(image) do
    "#{Slug.slugify(image.title)}+#{image.slug}"
  end

  def path(path) do
    "#{NappyWeb.Endpoint.url()}/#{path}"
  end

  def social_media do
    %{
      "instagram" => "https://www.instagram.com/nappystock",
      "twitter" => "https://www.twitter.com/nappystock",
      "facebook" => "https://www.facebook.com/nappystock"
    }
  end

  def uploads_priv_dir do
    :code.priv_dir(:nappy)
    # Path.join([:code.priv_dir(:nappy), "static", "uploads"])
  end

  def slug_paths_filename do
    "priv/repo/slug_paths.txt"
  end
end
