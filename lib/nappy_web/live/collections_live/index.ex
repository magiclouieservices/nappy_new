defmodule NappyWeb.CollectionsLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  # alias Plug.Conn.Status

  @impl true
  def mount(_params, _session, socket) do
    collections = Catalog.list_collection_description()
    related_tags = Catalog.random_tags(10)

    socket =
      socket
      |> assign(collections: collections)
      |> assign(related_tags: related_tags)

    {:ok, socket}
  end
end
