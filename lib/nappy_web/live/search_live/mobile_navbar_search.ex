defmodule NappyWeb.SearchLive.MobileNavbarSearch do
  use NappyWeb, :inline_live_view

  alias Nappy.Catalog
  alias Nappy.SponsoredImages

  @moduledoc false

  @impl true
  def handle_event("search", %{"mobile_search_phrase" => mobile_query}, socket) do
    sponsored_images = SponsoredImages.get_images("search-#{mobile_query}", mobile_query)
    route = Routes.search_show_path(socket, :show, mobile_query)

    socket =
      socket
      |> assign(query: mobile_query)
      |> assign(sponsored_images: sponsored_images)
      |> redirect(to: route)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      x-data="{
        open: false,
        toggle() {
          this.$refs.button.focus()

          this.open = true
        },
      }"
      class="flex"
    >
      <.form
        :let={f}
        for={%{}}
        as={:search}
        method="get"
        class="flex grow justify-center relative"
        phx-submit="search"
      >
        <%= label f, :phrase, class: "relative w-full px-12" do %>
          <input
            @click="open = !open, toggle()"
            @click.outside="open = false"
            @keydown.escape.window="open = false"
            x-ref="button"
            name="search[mobile_search_phrase]"
            id="mobile_search_phrase"
            type="text"
            placeholder="Search for photos"
            class="appearance-none w-full block rounded border-gray-300 placeholder-gray-500 focus:outline-none focus:ring-gray-500 focus:border-gray-500 text-black"
            required
          />
          <div
            x-cloak
            x-show="open"
            x-transition.origin.top.left
            class="absolute left-12 mt-0.5 px-12 py-4 z-10 w-[calc(100%-6rem)] rounded text-black bg-white shadow-md"
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
                    src={Catalog.imgix_url(image, "photo")}
                  />
                  <%= get_tag_name(image.tags) %>
                </li>
              </a>
            </ul>
          </div>
          <%= submit [phx_submit: "search", class: "absolute inset-y-0 right-12 flex items-center px-3 text-gray-500 hover:text-green-500"] do %>
            <i class="fa-solid fa-magnifying-glass"></i>
          <% end %>
        <% end %>
      </.form>
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
