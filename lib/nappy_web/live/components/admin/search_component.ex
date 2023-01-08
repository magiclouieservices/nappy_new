defmodule NappyWeb.Components.Admin.SearchComponent do
  use NappyWeb, :live_component

  alias Nappy.Search

  @moduledoc false

  @impl true
  def handle_event("admin_search", %{"search_phrase" => search_phrase}, socket)
      when search_phrase == "" do
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "admin_search",
        %{"search_phrase" => search_phrase},
        %{assigns: assigns} = socket
      ) do
    search_phrase
    |> Search.changeset()
    |> case do
      %{valid?: true, changes: %{search_phrase: search_phrase}} ->
        params = [
          page: assigns.page,
          sort_by: assigns.sort_by,
          sort_order: assigns.sort_order,
          search_phrase: search_phrase,
          image_status: assigns.image_status
        ]

        images = Search.paginate_admin_search(search_phrase, params)

        socket =
          socket
          |> assign(images: images)
          |> assign(search_phrase: search_phrase)

        path = Routes.admin_images_path(socket, :images, params)

        {:noreply, push_patch(socket, to: path)}

      # {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end

  @doc """
  Live component for admin search.

  ## Examples

    <.live_component
      page={@page}
      sort_by={@sort_by}
      sort_order={@sort_order}
      search_phrase={@search_phrase}
      image_status={@image_status}
      module={SearchComponent}
      id="admin-search"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative flex h-12">
      <.form
        id="admin-search-hook"
        phx-hook="AdminSearch"
        for={:admin_search}
        phx-submit="admin_search"
        phx-target={@myself}
        class="flex justify-center items-center gap-2 relative"
      >
        <input
          id="admin-search"
          type="text"
          name="search_phrase"
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-gray-500 focus:ring-gray-500 sm:text-sm font-normal"
          placeholder="search images"
        />
        <button
          type="submit"
          id="admin-search-button"
          class="absolute right-2 rounded-full w-7 bg-gray-300 p-0.5"
          phx-submit="admin_search"
          phx-target={@myself}
        >
          <i class="fa-solid fa-magnifying-glass"></i>
        </button>
      </.form>
    </div>
    """
  end
end
