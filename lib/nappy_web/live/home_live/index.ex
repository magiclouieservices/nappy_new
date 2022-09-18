defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  # @impl true
  # def handle_params(params, _uri, socket) do
  #   images = catalog.paginate_images(params)
  #   {:noreply, assign(socket, :images, images)}
  # end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page: 1)
     |> assign(page_size: 12), temporary_assigns: [images: []]}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_images(:featured, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
