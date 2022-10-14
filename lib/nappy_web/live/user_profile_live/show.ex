defmodule NappyWeb.UserProfileLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Components.GalleryComponent

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    placeholder = Enum.map(1..12, fn _ -> "#" end)

    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(user: nil)

    {:ok, socket, temporary_assigns: [images: placeholder]}
  end

  @impl true
  def handle_params(%{"username" => username} = params, uri, socket) do
    user = Accounts.get_user_by_username(username)

    socket =
      socket
      |> assign(page: 1)
      |> assign(page_size: 12)
      |> assign(user: user)
      |> assign(current_url: uri)

    {:noreply, socket}
  end

  @impl true
  def handle_event("load-more", _unsigned_params, %{assigns: assigns} = socket) do
    {:noreply, assign(socket, page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{user: user, page: page, page_size: page_size}} = socket) do
    images = Catalog.paginate_user_images(user.username, page: page, page_size: page_size)
    assign(socket, images: images)
  end
end
