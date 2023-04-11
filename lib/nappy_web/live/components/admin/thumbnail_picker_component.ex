defmodule NappyWeb.Components.Admin.ThumbnailPickerComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog

  @moduledoc false

  @doc """
  Thumbnail picker component, but admin can only use this.

  ## Examples

    <.live_component
      module={ThumbnailPickerComponent}
      id="thumbnail-picker"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div
      phx-hook="ThumbnailPicker"
      id="thumbnail-picker"
      class="grid
         lg:grid-cols-9
         sm:grid-cols-6
         xs:grid-cols-3
         gap-8"
    >
      <%= for image <- list_collection_images(@slug) do %>
        <button
          x-data="{ hidden: true }"
          class="relative w-full h-full bg-slate-300 rounded flex justify-center items-center"
        >
          <input
            class="absolute hidden"
            type="radio"
            name="thumbnail"
            value={image.slug}
            form="update-collection-thumbnail"
            checked={if image.id === @collection_desc.thumbnail, do: "true", else: nil}
          />
          <div
            x-on:mouseenter="hidden = false"
            x-on:mouseleave="hidden = true;"
            x-bind:class="{'bg-[rgba(0,0,0,0.7)]': !hidden}"
            class="w-full h-full absolute rounded"
          >
          </div>
          <img
            loading="lazy"
            class="object-cover w-full h-full rounded"
            src={Catalog.image_url(image, w: 650)}
            alt={image.title}
          />
          <span class="hidden rounded-full bg-green-700 absolute flex justify-center items-center w-12 h-12 p-1.5">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="4"
              stroke="currentColor"
              class="w-8 h-8 text-white"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
            </svg>
          </span>
          <span
            :if={image.id === @collection_desc.thumbnail}
            class="font-tiempos-bold text-2xl p-4 w-full h-full text-white absolute bottom-0 left-0 flex justify-center items-center bg-[rgba(0,0,0,0.7)] rounded"
            href="#"
          >
            Current Thumbnail
          </span>
        </button>
      <% end %>
    </div>
    """
  end

  def list_collection_images(slug) do
    Catalog.list_collection_images(slug)
  end
end
