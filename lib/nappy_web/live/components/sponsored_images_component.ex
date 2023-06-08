defmodule NappyWeb.Components.SponsoredImagesComponent do
  use NappyWeb, :live_component

  @moduledoc false

  @doc """
  Show sponsored images from iStock
  using GettyImages API.

  ## Examples

    <.live_component
      module={SponsoredImagesComponent}
      id="sponsored-image-1"
      image={@image}
    />
  """
  def render(assigns) do
    ~H"""
    <div>
      <p class="font-tiempos-bold text-center text-3xl">Sponsored Photos</p>
      <div class="flex gap-2 xs:my-6 md:my-2">
        <div
          :for={{sponsored_img, index_pos} <- Enum.with_index(@sponsored_images)}
          class={"#{hide_extra_on_mobile(index_pos)} bg-slate-300 h-48 md:w-96 xs:w-auto rounded"}
        >
          <%= unless sponsored_img === "#" do %>
            <a
              id={"#{sponsored_img["id"]}-slug-#{@image_slug}"}
              class="relative bg-slate-300"
              href={sponsored_img["referral_link"]}
              title={sponsored_img["image_alt"]}
            >
              <%= if sponsored_img == check_last_elem(@sponsored_images) do %>
                <img
                  loading="lazy"
                  class="object-cover w-full h-full"
                  src={sponsored_img["image_src"]}
                  alt={sponsored_img["image_alt"]}
                />
                <span class="absolute inset-0 flex gap-2 items-center justify-center bg-[rgba(0,0,0,.5)] text-white">
                  <i class="fa-regular fa-images"></i> View more
                </span>
              <% else %>
                <img
                  loading="lazy"
                  class="object-cover w-full h-full rounded"
                  src={sponsored_img["image_src"]}
                  alt={sponsored_img["image_alt"]}
                />
              <% end %>
            </a>
          <% end %>
        </div>
      </div>

      <div class="my-8 flex justify-center">
        <span class="py-1 md:px-20 xs:px-4 sm:px-12 bg-black text-white text-center">
          Premium photos by iStock | Use code NAPPY15 for 15% off
        </span>
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

  def check_last_elem(sponsored_images) do
    Enum.at(sponsored_images, length(sponsored_images) - 1)
  end
end
