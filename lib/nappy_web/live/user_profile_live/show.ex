defmodule NappyWeb.UserProfileLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def handle_params(%{"username" => username} = _params, uri, socket) do
    user = Accounts.get_user_by_username(username)
    profile_metrics = Metrics.get_profile_page_metrics(user)

    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(user: user)
      |> assign(current_url: uri)
      |> assign(profile_metrics: profile_metrics)
      |> assign(page_title: ~s(#{user.username}'s Profile))
      |> fetch()

    {:noreply, socket}
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

  defp fetch(%{assigns: %{user: user, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_user_images(user.username, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
