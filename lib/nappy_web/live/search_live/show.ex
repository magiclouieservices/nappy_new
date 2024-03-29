defmodule NappyWeb.SearchLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.Search
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.HeaderSearchComponent
  alias NappyWeb.Components.SponsoredImagesComponent

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [{SEO.key(), nil}]}
  end

  @impl true
  def handle_params(%{"query" => query}, uri, socket) do
    sponsored_images = SponsoredImages.get_images("search-#{query}", [query])
    page_title = "#{query} Photos"

    seo = %{
      title: page_title,
      description: page_title,
      url: Routes.search_show_url(socket, :show, query)
    }

    socket =
      socket
      |> assign(query: query)
      |> assign(sponsored_images: sponsored_images)
      |> prepare_assigns(uri)
      |> SEO.assign(seo)
      |> fetch()

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, push_navigate(socket, to: "/", replace: true)}
  end

  @impl true
  def handle_event("increment_view_count", %{"slug" => slug}, socket) do
    slug
    |> Metrics.get_image_analytics_by_slug()
    |> Metrics.increment_view_count()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search_phrase" => query}, socket) do
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

  @impl true
  def handle_event("set_collection", params, socket) do
    collection_slugs =
      Enum.reduce(params, [], fn {slug, state}, acc ->
        if state === "on", do: [slug | acc], else: acc
      end)

    image_slug = Map.get(params, "image_slug")

    path = URI.parse(socket.assigns[:current_url]).path
    current_user = socket.assigns[:current_user]
    attrs = %{user_id: current_user.id}

    socket =
      case Catalog.set_image_to_existing_collections(collection_slugs, image_slug, attrs) do
        {:ok, _} ->
          Enum.each(collection_slugs, &Cachex.del(Nappy.cache_name(), {"collection_#{&1}"}))

          put_flash(socket, :info, "Successfully updated")

        {:error, _reason} ->
          put_flash(socket, :error, "Error adding image to collections")
      end

    Process.send_after(self(), :clear_info, 5_000)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event(
        "new_collection",
        %{"collection_title" => title, "image_slug" => image_slug},
        socket
      ) do
    path = URI.parse(socket.assigns[:current_url]).path
    current_user = socket.assigns[:current_user]

    attrs = %{user_id: current_user.id, title: title}

    socket =
      case Catalog.add_image_to_new_collection(image_slug, attrs) do
        {:ok, _} -> put_flash(socket, :info, "Image added to collection")
        {:error, _reason} -> put_flash(socket, :error, "Error adding image to collection")
      end

    Process.send_after(self(), :clear_info, 5_000)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end

  defp prepare_assigns(socket, uri) do
    socket
    |> assign(page: 1)
    |> assign(page_size: 12)
    |> assign(current_url: uri)
  end

  defp fetch(%{assigns: %{query: query, page: page, page_size: page_size}} = socket) do
    args = [query, [page: page, page_size: page_size]]
    mfa = {__MODULE__, :search_images, args}
    images = Catalog.insert_adverts_in_paginated_images("image_search", mfa)
    entries = Map.get(images, :entries) || []
    contains_sponsored? = Enum.any?(entries, &Map.has_key?(&1, :sponsored))

    images =
      if length(images.entries) === 1 and contains_sponsored? do
        entries = []
        Map.put(images, :entries, entries)
      else
        images
      end

    assign(socket, images: images)
  end

  def search_images(query, params) do
    query
    |> Search.changeset()
    |> case do
      %{valid?: true, changes: %{search_phrase: search_phrase}} ->
        Search.paginate_search(search_phrase, params)

      _ ->
        %Scrivener.Page{
          page_number: params[:page],
          page_size: params[:page_size],
          total_entries: 0,
          total_pages: 1,
          entries: []
        }
    end
  end
end
