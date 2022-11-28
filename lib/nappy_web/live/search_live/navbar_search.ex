defmodule NappyWeb.SearchLive.NavbarSearch do
  use NappyWeb, :inline_live_view

  alias Nappy.Catalog
  alias Nappy.SponsoredImages

  @moduledoc false

  @impl true
  def handle_event("search", %{"search" => %{"search_phrase" => query}}, socket) do
    sponsored_images = SponsoredImages.get_images("search-#{query}", query)
    route = Routes.search_show_path(socket, :show, query)

    socket =
      socket
      |> assign(query: query)
      |> assign(sponsored_images: sponsored_images)
      |> push_navigate(to: route, replace: true)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      x-data="{open: false,
        parentOpen: true,
        toggle() {
          this.$refs.button.focus()

          this.open = true
        },
      }"
      class="flex"
    >
      <.form
        :let={f}
        for={:search}
        method="get"
        class="flex justify-center relative"
        phx-submit="search"
        x-cloak
        x-show="open"
        x-on:click.outside="open = false, parentOpen = true"
      >
        <%= label f, :phrase, class: "relative" do %>
          <input
            x-ref="button"
            name="search[search_phrase]"
            id="search_phrase"
            type="text"
            placeholder="Search for photos"
            class="appearance-none block w-96 rounded border-gray-300 placeholder-gray-500 focus:outline-none focus:ring-gray-500 focus:border-gray-500 text-black"
          />
          <div
            x-cloak
            x-show="open"
            x-transition.origin.top.left
            class="absolute left-0 mt-0.5 p-4 z-10 w-full rounded text-black bg-white shadow-md"
          >
            <p>Trending Topics</p>
            <ul class="my-2 flex flex-wrap gap-2">
              <a
                :for={image <- get_trends()}
                href={Routes.search_show_path(@socket, :show, get_tag_name(image.tags))}
                class="hover:bg-gray-50"
              >
                <li class="flex gap-2 items-center border rounded py-1 px-2 text-sm">
                  <img
                    class="object-cover w-8 h-8 rounded-full"
                    src={Catalog.image_url(image, w: 150, q: 0, cs: "tinysrgb", auto: "compress")}
                  />
                  <%= get_tag_name(image.tags) %>
                </li>
              </a>
            </ul>
          </div>
        <% end %>
        <button
          phx-submit="search"
          class="absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 hover:text-green-500"
        >
          <i class="fa-solid fa-magnifying-glass"></i>
        </button>
      </.form>
      <button
        x-show="parentOpen"
        @click="open = !open, parentOpen = !parentOpen, toggle()"
        @click.outside="open = false, parentOpen = true"
        @keydown.escape.window="open = false, parentOpen = true"
        class="flex p-1 items-center focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
      >
        <i class="text-gray-900 fa-solid fa-magnifying-glass"></i>
      </button>
    </div>
    """
  end

  def get_tag_name(tags) do
    String.split(tags, ",") |> hd()
  end

  def get_trends do
    Catalog.get_trend_search_bar()
  end
end
