defmodule NappyWeb.NotifLive.Show do
  use NappyWeb, :inline_live_view

  @moduledoc false

  @impl true
  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }" class="relative text-left">
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
          <%= 2 %>
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
        class="absolute flex w-64 left-[-200%] rounded flex-col px-4 py-6 gap-2 items-start justify-center mt-1 bg-black text-white z-50"
      >
        <li>
          <i class="fa-solid fa-heart"></i> User1234 liked your photo
        </li>
        <li>
          <i class="fa-solid fa-heart"></i> John liked your photo
        </li>
      </ul>
    </div>
    """
  end
end
