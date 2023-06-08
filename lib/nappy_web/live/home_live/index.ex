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
