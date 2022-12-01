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
      |> assign(page_title: "Collections")

    {:ok, socket}
  end

  def truncate_related_tags(related_tag) do
    if String.length(related_tag) > 13 do
      String.slice(related_tag, 0..12) <> "..."
    else
      related_tag
    end
  end
end
