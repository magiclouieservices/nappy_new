defmodule NappyWeb.Components.Admin.MultiTagSelect do
  use NappyWeb, :live_component

  @moduledoc false

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-1 border border-gray-300 rounded rounded-md bg-white p-1">
      <div
        :for={tag <- Enum.reverse(@tags)}
        phx-click="remove_tag"
        phx-value-tag={tag}
        class="flex justify-center items-center rounded text-black bg-gray-300 p-1"
      >
        <%= tag %>
        <span class="flex justify-center items-center cursor-pointer ml-2">x</span>
      </div>
      <input
        class="flex-1 appearance-none border border-0 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-transparent focus:border-transparent focus:z-10 sm:text-sm"
        id="form_field"
        phx-hook="MultiSelectTags"
        phx-target={@myself}
        type="text"
      />
    </div>
    """
  end
end
