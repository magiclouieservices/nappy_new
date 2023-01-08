defmodule NappyWeb.Components.Admin.ImagesFilterImageStatusComponent do
  use NappyWeb, :live_component

  @moduledoc false

  @doc """
  Filter by status for /admin/images.

  ## Examples

    <.live_component
      module={ImagesFilterImageStatusComponent}
      id="admin-filter-image-status"
    />
  """
  def render(assigns) do
    ~H"""
    <div class="flex text-sm justify-center gap-2 font-normal">
      <span class="self-center">filter by:</span>
      <div class="flex gap-2">
        <button
          :for={
            {image_status, class_name} <-
              [
                all: "border border-black",
                active: "bg-green-100 text-green-800 border-green-900",
                denied: "bg-red-100 text-red-800 border-red-900",
                featured: "bg-indigo-100 text-indigo-800 border-indigo-900",
                pending: "bg-yellow-100 text-yellow-800 border-yellow-900"
              ]
          }
          phx-click="filter_by_image_status"
          phx-value-image_status={image_status}
          class={"#{class_name} px-1 py-0.5 border rounded text-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"}
        >
          <%= image_status %>
        </button>
      </div>
    </div>
    """
  end
end
