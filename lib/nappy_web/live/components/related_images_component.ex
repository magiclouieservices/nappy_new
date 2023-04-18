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
        <div
          :for={{related_img, index_pos} <- Enum.with_index(@related_images)}
          class={"#{hide_extra_on_mobile(index_pos)} bg-slate-300 h-48 md:w-96 xs:w-auto"}
        >
          <%= unless related_img === "#" do %>
            <a
              class="relative"
              href={Routes.image_show_path(@socket, :show, Nappy.slug_link(related_img))}
              title={related_img.title}
            >
              <img
                loading="lazy"
                class="object-cover w-full h-full"
                src={Catalog.imgix_url(related_img, "photo")}
                alt={related_img.title}
              />
            </a>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def hide_extra_on_mobile(index_pos) do
    cond do
      index_pos === 1 -> "xs:hidden sm:block"
      index_pos === 2 -> "xs:hidden md:block"
      index_pos === 3 -> "xs:hidden lg:block"
      true -> "block"
    end
  end
end
