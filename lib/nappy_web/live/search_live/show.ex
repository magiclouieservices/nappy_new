defmodule NappyWeb.SearchLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Search
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.HeaderSearchComponent
  alias NappyWeb.Components.SponsoredImagesComponent

  @moduledoc false

  @impl true
  def handle_params(%{"query" => query}, uri, socket) do
    sponsored_images = SponsoredImages.get_images("search-#{query}", query)

    socket =
      socket
      |> assign(query: query)
      |> assign(sponsored_images: sponsored_images)
      |> prepare_assigns(uri)
      |> fetch()

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, push_navigate(socket, to: "/", replace: true)}
  end

  @impl true
  def handle_event("search", %{"search" => %{"search_phrase" => query}}, socket) do
    sponsored_images = SponsoredImages.get_images("search-#{query}", query)
    route = Routes.search_show_path(socket, :show, query)

    socket =
      socket
      |> assign(query: query)
      |> assign(sponsored_images: sponsored_images)
      |> push_navigate(to: route, replace: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp prepare_assigns(socket, uri) do
    socket
    |> assign(page: 1)
    |> assign(page_size: 12)
    |> assign(current_url: uri)
  end

  defp fetch(%{assigns: %{query: query, page: page, page_size: page_size}} = socket) do
    images = search_images(query, page: page, page_size: page_size)
    assign(socket, images: images)
  end

  defp search_images(query, params) do
    query
    |> Search.changeset()
    |> case do
      %{valid?: true, changes: %{search_phrase: search_phrase}} ->
        Search.paginate_search(search_phrase, params)

      _ ->
        []
    end
  end
end
