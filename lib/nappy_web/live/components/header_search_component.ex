defmodule NappyWeb.Components.HeaderSearchComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog

  @moduledoc false

  @impl true
  def handle_event("search", %{"search_phrase" => query}, socket) do
    route = Routes.search_show_path(socket, :show, query)

    {:noreply, redirect(socket, to: route)}
  end

  @doc """
  Live component for search (header part).

  ## Examples

    <.live_component
      module={HeaderSearchComponent}
      id="header-search"
    />
  """
  @impl true
  def render(assigns) do
    # assigns =
    #   assigns
    #   |> assign_new(:tags, fn -> placeholder end)

    ~H"""
    <div x-data="{ open: false }">
      <.form
        :let={f}
        for={%{}}
        as={:search}
        phx-submit="search"
        phx-target={@myself}
        class="flex justify-center relative"
        x-on:click="open = !open"
        x-on:keydown="open = true"
        x-on:keydown.escape.window="open = false"
        x-on:click.outside="open = false"
      >
        <%= label f, :search_phrase, class: "relative" do %>
          <input
            name="search_phrase"
            id="search_phrase"
            type="text"
            placeholder="Search for photos..."
            class="appearance-none block lg:w-[28rem] md:w-96 xs:w-72 rounded border-gray-300 placeholder-gray-500 focus:outline-none focus:ring-gray-500 focus:border-gray-500 text-black xs:text-base"
            required
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
                :for={{search_term, image} <- get_trends()}
                href={Routes.search_show_path(@socket, :show, search_term)}
                class="hover:bg-gray-50"
              >
                <li class="flex gap-2 items-center border rounded py-1 px-2 text-sm">
                  <img
                    class="object-cover w-8 h-8 rounded-full"
                    src={Catalog.imgix_url(image, "photo")}
                  />
                  <%= search_term %>
                </li>
              </a>
            </ul>
          </div>
        <% end %>
        <button
          type="submit"
          phx-submit="search"
          phx-target={@myself}
          class="absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 hover:text-green-500"
        >
          <i class="fa-solid fa-magnifying-glass"></i>
        </button>
      </.form>
    </div>
    """
  end

  def get_trends do
    Catalog.get_trend_search_bar()
    |> Enum.reduce([[], []], fn image, acc ->
      [images, already_picked] = acc
      tags = List.flatten(image.tags, image.generated_tags) |> Enum.uniq()

      if Enum.random(tags) in already_picked do
        tag = Enum.random(tags -- already_picked)

        [[{tag, image} | images], [tag | already_picked]]
      else
        tag = Enum.random(tags)

        [[{tag, image} | images], [tag | already_picked]]
      end
    end)
    |> hd()
  end
end
