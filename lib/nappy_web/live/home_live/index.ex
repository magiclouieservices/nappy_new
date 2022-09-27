defmodule NappyWeb.HomeLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false
  @impl true
  def mount(%{"filter" => filter}, _uri, socket)
      when filter in ["popular", "all"] do
    filter = String.to_existing_atom(filter)

    {
      :ok,
      prepare_assigns(socket, filter: filter),
      temporary_assigns: [images: []]
    }
  end

  @impl true
  def mount(_, _uri, socket) do
    {
      :ok,
      prepare_assigns(socket),
      temporary_assigns: [images: []]
    }
  end

  defp prepare_assigns(socket, filter \\ [filter: :featured]) do
    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(filter)

    if connected?(socket) do
      fetch(socket)
    else
      socket
    end
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{filter: filter, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_images(filter, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
