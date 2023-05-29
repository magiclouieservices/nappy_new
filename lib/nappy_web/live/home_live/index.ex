defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.HomeHeaderComponent

  @moduledoc false

  @impl true
  def handle_params(%{"filter" => filter}, uri, socket)
      when filter in ["popular", "all"] do
    page_title = ~s(#{String.capitalize(filter)} Photos)
    filter = String.to_existing_atom(filter)

    {
      :noreply,
      prepare_assigns(socket, uri, page_title, filter: filter)
    }
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {
      :noreply,
      prepare_assigns(socket, uri)
    }
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

  defp prepare_assigns(socket, uri, page_title \\ "Nappy", filter \\ [filter: :featured]) do
    socket
    |> assign(page: 1)
    |> assign(page_size: 12)
    |> assign(current_url: uri)
    |> assign(page_title: page_title)
    |> assign(filter)
    |> fetch()
  end

  defp fetch(%{assigns: %{filter: filter, page: page, page_size: page_size}} = socket) do
    args = [filter, [page: page, page_size: page_size]]
    mfa = {Catalog, :paginate_images, args}
    images = Catalog.insert_adverts_in_paginated_images("homepage", mfa)
    assign(socket, images: images)
  end
end
