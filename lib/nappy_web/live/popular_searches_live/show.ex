defmodule NappyWeb.PopularSearchesLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog

  @moduledoc false

  def mount(_params, _session, socket) do
    images = Catalog.get_popular_searches()
    page_title = "Popular searches on Nappy"

    seo = %{
      title: page_title,
      description: "The most popular search terms on Nappy",
      url: Routes.popular_searches_show_url(socket, :show)
    }

    socket =
      socket
      |> assign(images: images)
      |> SEO.assign(seo)

    {:ok, socket}
  end

  def get_first_tag(tags) do
    tags
    |> String.split(",")
    |> hd()
  end
end
