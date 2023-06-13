defmodule NappyWeb.SEO do
  alias NappyWeb.Router.Helpers, as: Routes

  @moduledoc false

  use SEO,
    json_library: Jason,
    site: &__MODULE__.site_config/1,
    open_graph:
      SEO.OpenGraph.build(
        site_name: "Nappy",
        locale: "en_US"
      ),
    facebook: SEO.Facebook.build(app_id: Nappy.facebook_app_id()),
    twitter:
      SEO.Twitter.build(
        site: Nappy.twitter_handle(),
        site_id: Nappy.twitter_site_id(),
        creator: Nappy.twitter_handle(),
        creator_id: Nappy.twitter_site_id(),
        card: :summary
      )

  def site_config(conn) do
    SEO.Site.build(
      default_title: "Nappy",
      default_description:
        "Beautiful photos of Black and Brown people, for free. For commercial and personal use.",
      title_suffix: " | Beautifully Diverse Stock Photos",
      theme_color: "#000000",
      windows_tile_color: "#000000",
      mask_icon_color: "#000000",
      mask_icon_url: Routes.static_path(conn, "/images/single-letter-logo.png")
    )
  end
end
