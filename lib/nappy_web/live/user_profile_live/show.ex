defmodule NappyWeb.UserProfileLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [{SEO.key(), nil}]}
  end

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

    {:noreply, SEO.assign(socket, user)}
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
    args = [user.username, [page: page, page_size: page_size]]
    mfa = {Catalog, :paginate_user_images, args}
    images = Catalog.insert_adverts_in_paginated_images("user_profile", mfa)
    assign(socket, images: images)
  end
end
