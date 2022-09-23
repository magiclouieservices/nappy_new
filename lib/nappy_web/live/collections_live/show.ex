defmodule NappyWeb.CollectionsLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def handle_params(%{"slug" => slug}, _uri, socket) do
    coll_desc = Catalog.get_collection_description_by_slug(slug)

    {:noreply,
     socket
     |> assign(page: 1)
     |> assign(page_size: 12)
     |> assign(slug: slug)
     |> assign(collection: coll_desc)
     |> fetch()}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_collection(slug, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
