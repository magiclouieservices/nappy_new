defmodule NappyWeb.CollectionsLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.Admin.EditCollectionPageComponent
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.RelatedTagsComponent
  alias Plug.Conn.Status
  @moduledoc false

  @impl true
  def handle_params(%{"slug" => slug}, uri, socket) do
    if Map.get(socket.assigns, :flash) do
      Process.send_after(self(), :clear_info, 5_000)
    end

    collection = Catalog.get_collection_by_slug(slug)

    case collection do
      nil ->
        raise NappyWeb.FallbackController, Status.code(:not_found)

      _ ->
        related_tags =
          if collection.related_tags do
            collection.related_tags
            |> String.split(",", trim: true)
          else
            []
          end

        socket =
          socket
          |> assign(page: 1)
          |> assign(page_size: 12)
          |> assign(slug: slug)
          |> assign(collection: collection)
          |> assign(current_url: uri)
          |> assign(related_tags: related_tags)
          |> assign(page_title: collection.title)
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

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    args = [slug, [page: page, page_size: page_size]]
    mfa = {Catalog, :paginate_collection, args}
    images = Catalog.insert_adverts_in_paginated_images("collection", mfa)
    assign(socket, images: images)
  end
end
