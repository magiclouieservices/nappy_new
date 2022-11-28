defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
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
  def handle_event("search", %{"search" => %{"search_phrase" => query}}, socket) do
    route = Routes.search_show_path(socket, :show, query)

    {:noreply, redirect(socket, to: route)}
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
    payload_name = "homepage_#{filter}"
    ttl = :timer.hours(1)

    images =
      if page === 1 do
        args = [filter, [page: page, page_size: page_size]]
        mfa = [Catalog, :paginate_images, args]

        Nappy.Caching.paginated_images_payload(mfa, payload_name, ttl)
      else
        Catalog.paginate_images(filter, page: page, page_size: page_size)
      end

    assign(socket, images: images)
  end
end
