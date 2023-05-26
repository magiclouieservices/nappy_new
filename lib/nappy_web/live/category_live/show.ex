defmodule NappyWeb.CategoryLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.Admin.EditCategoryPageComponent
  alias NappyWeb.Components.GalleryComponent
  alias Plug.Conn.Status

  @moduledoc false

  @impl true
  def handle_params(%{"slug" => slug}, uri, socket) do
    category = Catalog.get_category(slug: slug)

    case category do
      nil ->
        raise NappyWeb.FallbackController, Status.code(:not_found)

      _ ->
        related_tags =
          category.related_tags
          |> String.split(",", trim: true)

        socket =
          socket
          |> assign(page: 1)
          |> assign(page_size: 12)
          |> assign(slug: slug)
          |> assign(current_url: uri)
          |> assign(related_tags: related_tags)
          |> assign(category: category)
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

  @impl true
  def handle_event("add_new_collection", %{"input" => value}, socket) do
    socket =
      socket
      |> put_flash(:info, "value is #{value}")

    Process.send_after(self(), :clear_info, 5_000)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    args = [slug, [page: page, page_size: page_size]]
    mfa = {Catalog, :paginate_category, args}
    images = Catalog.insert_adverts_in_paginated_images("category", mfa)
    assign(socket, images: images)
  end
end
