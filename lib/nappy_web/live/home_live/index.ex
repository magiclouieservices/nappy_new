defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def handle_params(%{"filter" => filter}, uri, socket)
      when filter in ["popular", "all"] do
    {:noreply,
     socket
     |> assign(page: 1)
     |> assign(page_size: 12)
     |> assign(filter: String.to_existing_atom(filter))
     |> assign(uri: URI.parse(uri))
     |> fetch()}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply,
     socket
     |> assign(page: 1)
     |> assign(page_size: 12)
     |> assign(filter: :featured)
     |> assign(uri: URI.parse(uri))
     |> assign(images: [])}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{filter: filter, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_images(filter, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
