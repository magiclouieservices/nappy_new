defmodule NappyWeb.Components.GalleryComponent do
  use NappyWeb, :live_component
  alias Nappy.{Accounts, Catalog}

  @moduledoc false

  defp calc_span(metadata) do
    ratio = Float.floor(metadata.width / metadata.height, 2)

    cond do
      ratio <= 0.79 -> "row-span-2"
      ratio === 1.0 -> "row-span-1"
      true -> "row-span-1"
    end
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
        class="grid grid-cols-3 auto-rows-[32rem] gap-2"
      >
        <%= for image <- @images do %>
          <div id={"image-#{image.slug}"} class={"#{calc_span(image.image_metadata)}
            relative bg-slate-300"}>
            <a href={Routes.image_show_path(@socket, :show, image.slug)}>
              <img
                loading="lazy"
                class="object-cover w-full h-full"
                src={Catalog.image_url(image, w: 850, auto: "format")}
                alt={image.title}
              />
            </a>
            <a
              class="absolute bottom-4 left-4 flex gap-2 items-center"
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
