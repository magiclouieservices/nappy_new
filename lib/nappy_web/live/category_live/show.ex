defmodule NappyWeb.CategoryLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.RelatedTagsComponent
  alias Plug.Conn.Status

  @moduledoc false

  @impl true
  def handle_params(%{"slug" => slug}, uri, socket) do
    category = Catalog.get_category(slug: slug)

    case category do
      nil ->
        raise NappyWeb.FallbackController, Status.code(:not_found)

      _ ->
        related_tags = Catalog.consolidate_tags_by_category(category.id)

        socket =
          socket
          |> assign(page: 1)
          |> assign(page_size: 12)
          |> assign(slug: slug)
          |> assign(current_url: uri)
          |> assign(related_tags: related_tags)
          |> assign(page_title: category.name)
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
    payload_name = "category_#{slug}"
    ttl = :timer.hours(1)

    images =
      if page === 1 do
        args = [slug, [page: page, page_size: page_size]]
        mfa = [Catalog, :paginate_category, args]

        Nappy.Caching.paginated_images_payload(mfa, payload_name, ttl)
      else
        Catalog.paginate_category(slug, page: page, page_size: page_size)
      end

    assign(socket, images: images)
  end
end
