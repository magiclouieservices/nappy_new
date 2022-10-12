defmodule NappyWeb.Components.GalleryComponent do
  use NappyWeb, :live_component
  alias Nappy.{Accounts, Catalog}
  alias NappyWeb.Components.RelatedImagesComponent

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
        class="grid grid-cols-3 auto-rows-[50vh] gap-2"
      >
        <%= for image <- @images do %>
          <div
            x-data="{ hidden: true, open: false }"
            id={"image-#{image.slug}"}
            class={"#{calc_span(image.image_metadata)}
            relative bg-slate-300"}
          >
            <a
              x-on:click.prevent
              x-on:click={
                "open = !open; window.history.replaceState({}, '', '#{Routes.image_show_path(@socket, :show, Nappy.slug_link(image))}')"
              }
              class="relative"
              href={Routes.image_show_path(@socket, :show, Nappy.slug_link(image))}
            >
              <div
                x-on:mouseenter="hidden = false"
                x-on:mouseleave="hidden = true"
                x-bind:style="hidden ? '' : 'background: linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 20%);'"
                class="w-full h-full absolute"
              >
              </div>
              <img
                loading="lazy"
                class="object-cover w-full h-full"
                src={Catalog.image_url(image)}
                alt={image.title}
              />
            </a>
            <a
              x-on:mouseenter="hidden = false"
              x-on:mouseleave="hidden = true"
              x-bind:class="{'hidden': hidden}"
              class="p-4 text-white absolute bottom-0 left-0 flex gap-2 items-center hover:underline"
              href={Routes.user_profile_show_path(@socket, :show, image.user.username)}
            >
              <img
                class="rounded-full w-9 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
                src={Accounts.avatar_url(@socket, image.user.avatar_link)}
              />
              <span><%= image.user.username %></span>
            </a>
            <div
              x-show="open"
              style="display: none"
              x-on:keydown.escape.prevent.stop={
                "open = false; window.history.replaceState({}, '', '#{@current_url}')"
              }
              role="dialog"
              aria-modal="true"
              x-id={"['modal-#{image.slug}']"}
              x-bind:aria-labelledby={"$id('modal-#{image.slug}')"}
              class="fixed inset-0 z-10 overflow-y-auto"
            >
              <div x-show="open" x-transition.opacity class="fixed inset-0 bg-black bg-opacity-50">
              </div>
              <div
                x-show="open"
                x-transition
                x-on:click={"open = false; window.history.replaceState({}, '', '#{@current_url}')"}
                class="relative flex min-h-screen items-center justify-center p-12"
              >
                <button
                  x-on:click={"open = false; window.history.replaceState({}, '', '#{@current_url}')"}
                  type="button"
                  class="inline-flex text-white absolute left-4 top-4 flex flex-shrink-0 bg-border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 z-50"
                >
                  <svg aria-hidden class="h-10 w-10" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                      clip-rule="evenodd"
                    >
                    </path>
                  </svg>
                  <span class="sr-only">Close popup</span>
                </button>
                <div
                  x-on:click.stop
                  x-trap.noscroll.inert="open"
                  class="container relative w-full overflow-y-auto rounded bg-white p-8 shadow-lg"
                >
                  <div class="flex justify-between">
                    <a
                      class="flex gap-2 rounded items-center focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 hover:underline"
                      href={Routes.user_profile_show_path(@socket, :show, image.user.username)}
                    >
                      <img
                        class="rounded-full w-9 border"
                        src={Accounts.avatar_url(@socket, image.user.avatar_link)}
                      />
                      <span><%= image.user.username %></span>
                    </a>

                    <div class="flex gap-2">
                      <button
                        type="button"
                        class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                      >
                        <i class="fa-solid fa-circle-dollar-to-slot"></i>
                      </button>
                      <button
                        type="button"
                        class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                      >
                        <i class="fa-solid fa-reply fa-flip-horizontal"></i>
                      </button>
                      <%= if @current_user != nil do %>
                        <button
                          type="button"
                          class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                        >
                          <i class="fa-regular fa-heart"></i>
                        </button>
                      <% else %>
                        <a
                          class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                          href={Routes.user_session_path(@socket, :create)}
                        >
                          <i class="fa-regular fa-heart"></i>
                        </a>
                      <% end %>
                      <button
                        type="button"
                        class="inline-flex gap-2 justify-center items-center rounded-md bg-green-600 px-4 py-2 text-xs text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                      >
                        <span>Download</span>
                        <i class="fa-solid fa-chevron-down"></i>
                      </button>
                    </div>
                  </div>

                  <div class="my-4 flex justify-center">
                    <img
                      class="object-cover h-[75vh]"
                      src={Catalog.image_url(image)}
                      alt={image.title}
                    />
                  </div>

                  <div class="flex gap-8 justify-center">
                    <span>
                      <i class="fa-solid fa-eye"></i> 53.0k Views
                    </span>
                    <span>
                      <i class="fa-solid fa-heart"></i> 23 Saves
                    </span>
                    <span>
                      <i class="fa-solid fa-download"></i> 1.2k Downloads
                    </span>
                    <span>
                      <i class="fa-solid fa-circle-info"></i> more info
                    </span>
                  </div>

                  <.live_component
                    module={RelatedImagesComponent}
                    id={"related-image-#{image.slug}"}
                    image={image}
                  />
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
      <div id="infinite-scroll-marker" phx-hook="InfiniteScroll" data-page={@page}></div>
    </div>
    """
  end
end
