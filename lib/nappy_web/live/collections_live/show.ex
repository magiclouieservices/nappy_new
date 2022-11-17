defmodule NappyWeb.CollectionsLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.RelatedTagsComponent
  alias Plug.Conn.Status

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    placeholder =
      if connected?(socket) do
        []
      else
        Enum.map(1..12, fn _ -> "#" end)
      end

    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)

    {:ok, socket, temporary_assigns: [images: placeholder]}
  end

  @impl true
  def handle_params(%{"slug" => slug}, uri, socket) do
    coll_desc = Catalog.get_collection_description_by_slug(slug)

    case coll_desc do
      nil ->
        raise NappyWeb.FallbackController, Status.code(:not_found)

      _ ->
        related_tags = Catalog.consolidate_tags_by_collection(slug)

        socket =
          socket
          |> assign(page: 1)
          |> assign(page_size: 12)
          |> assign(slug: slug)
          |> assign(collection: coll_desc)
          |> assign(current_url: uri)
          |> assign(related_tags: related_tags)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(current_url: uri)

    {:noreply, socket}
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
