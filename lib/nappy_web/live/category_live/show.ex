defmodule NappyWeb.CategoryLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def mount(%{"slug" => slug} = params, _session, socket) do
    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(slug: slug)

    {:ok, socket, temporary_assigns: [images: []]}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_category(slug, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
