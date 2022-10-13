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
        <%= for sponsored_img <- @sponsored_images do %>
          <div class="bg-slate-300 grow h-72 basis-56">
            <%= unless sponsored_img === "#" do %>
              <div class="bg-slate-300 grow h-72 basis-56">
                <a class="relative" href={sponsored_img["referral_link"]}>
                  <img
                    loading="lazy"
                    class="object-cover w-full h-full"
                    src={sponsored_img["image_src"]}
                    alt={sponsored_img["image_alt"]}
                  />
                </a>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
