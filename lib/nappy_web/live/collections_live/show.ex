defmodule NappyWeb.CollectionsLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.RelatedTagsComponent
  alias Plug.Conn.Status

  @moduledoc false

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
          |> assign(page_title: coll_desc.title)
          |> fetch()

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  @impl true
  def handle_event("increment_view_count", %{"slug" => slug}, socket) do
    slug
    |> Metrics.get_image_analytics_by_slug()
    |> Metrics.increment_view_count()

    {:noreply, socket}
  end

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    payload_name = "collection_#{slug}"
    ttl = :timer.hours(1)

    images =
      if page === 1 do
        args = [slug, [page: page, page_size: page_size]]
        mfa = [Catalog, :paginate_collection, args]

        Nappy.Caching.paginated_images_payload(mfa, payload_name, ttl)
      else
        Catalog.paginate_collection(slug, page: page, page_size: page_size)
      end

    assign(socket, images: images)
  end
end
