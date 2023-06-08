defmodule NappyWeb.Components.Admin.ImagesPaginationComponent do
  use NappyWeb, :live_component

  @moduledoc false

  @doc """
  Pagination for /admin/images.

  ## Examples

    <.live_component
      images={@images}
      page={@page}
      sort_by={@sort_by}
      sort_order={@sort_order}
      search_phrase={@search_phrase}
      image_status={@image_status}
      socket={@socket}
      module={ImagesPaginationComponent}
      id="admin-images-pagination"
    />
  """
  def render(assigns) do
    ~H"""
    <tr class="h-12">
      <!-- image count results -->
      <th></th>
      <th class="pl-4">
        <div class="flex items-center gap-2">
          <!-- selected images count -->
          <!--
          <span class="text-sm font-normal">
            0 selected
          </span>
          -->
          <!-- end selected images count -->

          <!-- page count -->
          <span class="text-sm font-normal">
            (page <%= @images.page_number %> of <%= @images.total_pages %>)
          </span>
          <!-- end page count -->

          <!-- image result count -->
          <span :if={@images.total_entries < 1} class="text-sm font-normal">
            no image
          </span>
          <span :if={@images.total_entries === 1} class="text-sm font-normal">
            <%= @images.total_entries %> image
          </span>
          <span :if={@images.total_entries > 1} class="text-sm font-normal">
            <%= @images.total_entries %> images
          </span>
          <!-- end image result count -->
        </div>
      </th>
      <!-- end image count results -->

      <!-- next/prev button -->
      <th>
        <div class="flex items-center gap-2">
          <div class="flex gap-1">
            <!-- prev button -->
            <button
              :if={@images.page_number > 1}
              phx-click="prev"
              phx-value-sort_by={@sort_by}
              phx-value-sort_order={@sort_order}
              phx-value-page={@page}
              type="button"
              class="flex justify-center items-center rounded-md border border-gray-700 bg-gray-500 px-2 py-1 text-white text-xs shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
            >
              <!-- Heroicon name: outline/chevron-left -->
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
              </svg>
              prev
            </button>
            <!-- end prev button -->

            <!-- next button -->
            <button
              :if={@images.page_number < @images.total_pages}
              phx-click="next"
              phx-value-sort_by={@sort_by}
              phx-value-sort_order={@sort_order}
              phx-value-page={@page}
              type="button"
              class="flex justify-center items-center rounded-md border border-gray-700 bg-gray-500 px-2 py-1 text-white text-xs shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
            >
              next
              <!-- Heroicon name: outline/chevron-right -->
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
              </svg>
            </button>
            <!-- end next button -->
          </div>
          <!-- reset sorting button -->
          <.link
            navigate={Routes.admin_images_path(@socket, :images)}
            replace={true}
            class="flex justify-center items-center rounded-md border border-gray-700 bg-gray-500 px-2 py-1 text-white text-xs shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
          >
            reset sorting
          </.link>
          <!-- end reset sorting button -->
        </div>
      </th>
      <!-- end next/prev button -->
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
    """
  end
end
