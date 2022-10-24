defmodule Nappy do
  alias Nappy.Admin.Slug

  @moduledoc """
  Nappy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def app_name do
    Application.get_env(:nappy, :runtime)[:app_name]
  end

  def cache_name, do: :nappy_cache

  def support_email do
    Application.get_env(:nappy, :runtime)[:support_email]
  end

  def get_root_path(conn) do
    URI.parse(Phoenix.Controller.current_path(conn)).path
  end

  def slug_link(image) do
    "#{Slug.slugify(image.title)}-#{image.slug}"
  end

  def path(path) do
    "#{NappyWeb.Endpoint.url()}/#{path}"
  end

  def getty_api_key do
    Application.get_env(:nappy, :runtime)[:getty_api_key]
  end

  def getty_api_secret do
    Application.get_env(:nappy, :runtime)[:getty_api_secret]
  end

  def notifications_email do
    Application.get_env(:nappy, :runtime)[:notifications_email]
  end

  def subscription_url do
    Application.get_env(:nappy, :runtime)[:subscription_url]
  end

  def embed_url do
    Application.get_env(:nappy, :runtime)[:embed_url]
  end

  def bucket_name do
    Application.get_env(:nappy, :runtime)[:bucket_name]
  end

  def social_media do
    %{
      "instagram" => "https://www.instagram.com/nappystock",
      "twitter" => "https://www.twitter.com/nappystock",
      "facebook" => "https://www.facebook.com/nappystock"
    }
  end

  def image_paths do
    "/photos/"
  end

  def uploads_priv_dir do
    :code.priv_dir(:nappy)
    # Path.join([:code.priv_dir(:nappy), "static", "uploads"])
  end

  def slug_paths_filename do
    "priv/repo/slug_paths.txt"
  end
end
