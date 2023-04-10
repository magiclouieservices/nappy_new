defmodule NappyWeb.Components.Admin.ThumbnailPickerComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog

  @moduledoc false
  def list_collection_images(slug) do
    Catalog.list_collection_images(slug)
  end

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
    <div class="grid
         lg:grid-cols-9
         sm:grid-cols-6
         xs:grid-cols-3
         md:auto-rows-max
         xs:auto-rows-min
         gap-2">
      <%= for image <- list_collection_images(@slug) do %>
        <button
          phx-target={@myself}
          data-slug={image.slug}
          x-data="{ hidden: true, open: false, title: document.title }"
          id={"image-#{image.slug}"}
          class="row-span-1 relative bg-slate-300 rounded"
        >
          <img
            loading="lazy"
            class="object-cover w-full h-full rounded"
            src={Catalog.image_url(image, w: 650)}
            alt={image.title}
          />
        </button>
      <% end %>
    </div>
    """
  end
end
