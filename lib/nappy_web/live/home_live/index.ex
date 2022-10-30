defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.HomeHeaderComponent

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    placeholder =
      if connected?(socket) do
        []
      else
        Enum.map(1..12, fn _ -> "#" end)
      end

    {
      :ok,
      prepare_assigns(socket),
      temporary_assigns: [
        images: placeholder
      ]
    }
  end

  @impl true
  def handle_params(%{"filter" => filter}, uri, socket)
      when filter in ["popular", "all"] do
    filter = String.to_existing_atom(filter)

    {
      :noreply,
      prepare_assigns(socket, filter: filter)
      |> assign(current_url: uri)
    }
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {
      :noreply,
      prepare_assigns(socket)
      |> assign(current_url: uri)
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

  defp prepare_assigns(socket, filter \\ [filter: :featured]) do
    socket
    |> assign(page: 1)
    |> assign(page_size: 12)
    |> assign(filter)
  end

  defp fetch(%{assigns: %{filter: filter, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_images(filter, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
