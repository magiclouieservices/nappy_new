defmodule NappyWeb.Components.RelatedImagesComponent do
  use NappyWeb, :live_component
  alias Nappy.Catalog

  @moduledoc false

  @doc """
  Show related images from source.

  ## Examples

    <.live_component
      module={RelatedImagesComponent}
      id="related-image-1"
      image={@image}
    />
  """
  def render(assigns) do
    ~H"""
    <div class="my-8">
      <p class="font-tiempos-bold text-center text-3xl">Related Photos</p>
      <div class="flex gap-2 my-2">
        <%= for related_img <- related_images(@image) do %>
          <div class="bg-slate-300 grow h-72 basis-56">
            <a
              class="relative"
              href={Routes.image_show_path(@socket, :show, Nappy.slug_link(related_img))}
            >
              <img
                loading="lazy"
                class="object-cover w-full h-full"
                src={Catalog.image_url(related_img)}
                alt={related_img.title}
              />
            </a>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp related_images(image) do
    Catalog.get_related_images(image)
  end
end
