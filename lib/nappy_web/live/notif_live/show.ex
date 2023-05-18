defmodule NappyWeb.NotifLive.Show do
  use NappyWeb, :inline_live_view

  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics

  # @topic inspect(Nappy.Accounts)

  @moduledoc false

  @impl true
  def mount(_params, session, socket) do
    socket =
      case session do
        %{"user_token" => user_token} ->
          user = Accounts.get_user_by_session_token(user_token)
          pubsub_notif = Metrics.list_notifications_from_user(user.id)

          socket
          |> assign_new(:pubsub_notif, fn -> pubsub_notif end)

        %{} ->
          socket
          |> assign_new(:pubsub_notif, fn -> [] end)
      end

    {:ok, socket}
  end

  @impl true
  def handle_info(image, socket) do
    pubsub_notif = Metrics.list_notifications_from_user(image.user_id)

    socket =
      socket
      |> assign_new(:pubsub_notif, fn -> pubsub_notif end)

    {:noreply, socket}
  end

  defp count_unread_notifications(pubsub_notif) do
    length(pubsub_notif)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }" class="relative text-left">
      <%= if not Enum.empty?(@pubsub_notif) do %>
        <button
          @click="open = !open"
          @keydown.escape.window="open = false"
          @click.outside="open = false"
          class="relative flex p-2 items-center focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-7 w-7 text-gray-700"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
            />
          </svg>
          <span class="absolute right-0.5 top-0.5 inline-flex items-center rounded-full bg-pink-100 px-1.5 py-0.5 text-xs font-medium text-pink-700 border border-pink-300">
            <%= count_unread_notifications(@pubsub_notif) %>
          </span>
        </button>
        <ul
          x-cloak
          x-show="open"
          x-transition:enter="transition ease-out duration-100"
          x-transition:enter-start="transform opacity-0 scale-95"
          x-transition:enter-end="transform opacity-100 scale-100"
          x-transition:leave="transition ease-in duration-75"
          x-transition:leave-start="transform opacity-100 scale-100"
          x-transition:leave-end="transform opacity-0 scale-95"
          class="absolute flex w-72 left-[-200%] rounded flex-col px-4 py-6 gap-2 items-start justify-center mt-1 border bg-white text-black z-50"
        >
          <li :for={notif <- @pubsub_notif} class="flex gap-4 justify-between">
            <a
              href={
                Routes.image_show_path(
                  @socket,
                  :show,
                  Nappy.slug_link_by_id(notif.additional_foreign_key)
                )
              }
              class="flex gap-2 items-center hover:underline"
            >
              <img
                class="w-10 h-10 rounded-full"
                src={Catalog.imgix_url_by_id(notif.additional_foreign_key, w: 100)}
              />
              <span class="text-sm">
                <%= notif.description %>
              </span>
            </a>
            <button phx-click="remove_notif">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-6 h-6 text-gray-500 hover:text-black"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </li>
        </ul>
      <% else %>
        <button
          @click="open = !open"
          @keydown.escape.window="open = false"
          @click.outside="open = false"
          class="relative flex p-2 items-center focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-7 w-7 text-gray-700"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
            />
          </svg>
        </button>
        <div
          x-cloak
          x-show="open"
          x-transition:enter="transition ease-out duration-100"
          x-transition:enter-start="transform opacity-0 scale-95"
          x-transition:enter-end="transform opacity-100 scale-100"
          x-transition:leave="transition ease-in duration-75"
          x-transition:leave-start="transform opacity-100 scale-100"
          x-transition:leave-end="transform opacity-0 scale-95"
          class="absolute flex w-64 left-[-200%] rounded flex-col px-4 py-6 gap-2 mt-1 text-center border bg-white text-black z-50"
        >
          No new notification
        </div>
      <% end %>
    </div>
    """
  end
end
