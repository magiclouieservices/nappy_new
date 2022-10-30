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
      <div class="flex gap-2 my-2">
        <div :for={sponsored_img <- @sponsored_images} class="bg-slate-300 grow h-48 basis-56">
          <%= unless sponsored_img === "#" do %>
            <a
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
                  class="object-cover w-full h-full"
                  src={sponsored_img["image_src"]}
                  alt={sponsored_img["image_alt"]}
                />
              <% end %>
            </a>
          <% end %>
        </div>
      </div>

      <div class="my-8 flex justify-center">
        <span class="py-1 px-20 bg-black text-white text-center">
          Premium photos by iStock | Use code NAPPY15 for 15% off
        </span>
      </div>
    </div>
    """
  end

  def check_last_elem(sponsored_images) do
    Enum.at(sponsored_images, length(sponsored_images) - 1)
  end
end
