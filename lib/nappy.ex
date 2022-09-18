defmodule Nappy do
  @moduledoc """
  Nappy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def app_name do
    Application.get_env(:nappy, :runtime)[:app_name]
  end

  def support_email do
    Application.get_env(:nappy, :runtime)[:support_email]
  end

  def path(path) do
    "#{NappyWeb.Endpoint.url()}/#{path}"
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

  def image_paths(image_status) do
    path =
      case image_status do
        "approved" -> "approved"
        "pending" -> "pending"
        "denied" -> "denied"
        _ -> "404.jpg"
      end

    "/photos/#{path}/"
  end

  def uploads_priv_dir do
    :code.priv_dir(:nappy)
    # Path.join([:code.priv_dir(:nappy), "static", "uploads"])
  end

  def slug_paths_filename do
    "priv/repo/slug_paths.txt"
  end
end
