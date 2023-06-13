defmodule NappyWeb.CollectionsLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  # alias Plug.Conn.Status

  @impl true
  def mount(_params, _session, socket) do
    collections = Catalog.list_collections()
    related_tags = Catalog.random_tags(10)
    page_title = "Collections"

    seo = %{
      title: page_title,
      description: "Handpicked and curated photos grouped as collectons.",
      url: Routes.collections_index_url(socket, :index)
    }

    socket =
      socket
      |> assign(collections: collections)
      |> assign(related_tags: related_tags)
      |> assign(page_title: page_title)
      |> SEO.assign(seo)

    {:ok, socket}
  end
end
