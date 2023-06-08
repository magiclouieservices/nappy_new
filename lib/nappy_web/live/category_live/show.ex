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

  defp fetch(%{assigns: %{slug: slug, page: page, page_size: page_size}} = socket) do
    args = [slug, [page: page, page_size: page_size]]
    mfa = {Catalog, :paginate_category, args}
    images = Catalog.insert_adverts_in_paginated_images("category", mfa)
    assign(socket, images: images)
  end
end
