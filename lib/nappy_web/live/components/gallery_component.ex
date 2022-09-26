defmodule NappyWeb.Components.GalleryComponent do
  use NappyWeb, :live_component
  alias Nappy.{Accounts, Catalog}
  alias Nappy.Admin.Slug

  @moduledoc false

  defp calc_span(metadata) do
    ratio = Float.floor(metadata.width / metadata.height, 2)

    cond do
      ratio <= 0.79 -> "row-span-2"
      ratio === 1.0 -> "row-span-1"
      true -> "row-span-1"
    end
  end

  defp slug_link(image) do
    "#{Slug.slugify(image.title)}-#{image.slug}"
  end

  @doc """
  Live component of a gallery.

  ## Examples

    <.live_component
      module={GalleryComponent}
      id="infinite-gallery-home"
      images={@images}
      page={@page}
    />
  """
  def render(assigns) do
    ~H"""
    <div>
      <div
        id="infinite-scroll-body"
        phx-update="append"
        class="grid grid-cols-3 auto-rows-[50vh] gap-2"
      >
        <%= for image <- @images do %>
          <div
            x-data="{ hidden: true }"
            id={"image-#{image.slug}"}
            class={"#{calc_span(image.image_metadata)}
            relative bg-slate-300"}
          >
            <a class="relative" href={Routes.image_show_path(@socket, :show, slug_link(image))}>
              <div
                @mouseenter="hidden = false"
                @mouseleave="hidden = true"
                :style="hidden ? '' : 'background: linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 20%);'"
                class="w-full h-full absolute"
              >
              </div>
              <img
                loading="lazy"
                class="object-cover w-full h-full"
                src={Catalog.image_url(image, w: 850, auto: "format")}
                alt={image.title}
              />
            </a>
            <a
              @mouseenter="hidden = false"
              @mouseleave="hidden = true"
              :class="{'hidden': hidden}"
              class="p-4 text-white absolute bottom-0 left-0 flex gap-2 items-center"
              href={Routes.user_profile_path(@socket, :show, image.user.username)}
            >
              <img
                class="rounded-full w-9 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
                src={Accounts.avatar_url(@socket, image.user.avatar_link)}
              />
              <span><%= image.user.username %></span>
            </a>
          </div>
        <% end %>
      </div>
      <div id="infinite-scroll-marker" phx-hook="InfiniteScroll" data-page={@page}></div>
    </div>
    """
  end
end
