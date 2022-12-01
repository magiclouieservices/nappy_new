defmodule NappyWeb.Components.GalleryComponent do
  use NappyWeb, :live_component
  alias Nappy.Accounts
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.MoreInfoComponent
  alias NappyWeb.Components.RelatedImagesComponent
  alias NappyWeb.Components.SponsoredImagesComponent

  @moduledoc false

  def handle_event("show_images", %{"title" => title, "slug" => slug, "tags" => tags}, socket) do
    sponsored_images = SponsoredImages.get_images(slug, tags)
    related_images = related_images(slug)

    socket =
      socket
      |> assign(sponsored_images: sponsored_images)
      |> assign(related_images: related_images)
      |> assign(page_title: title)

    {:noreply, socket}
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
    placeholder = Enum.map(1..5, fn _ -> "#" end)

    assigns =
      assigns
      |> assign_new(:sponsored_images, fn -> placeholder end)
      |> assign_new(:related_images, fn -> placeholder end)

    ~H"""
    <div>
      <div
        id="infinite-scroll-body"
        phx-update="append"
        class="grid
          lg:grid-cols-3
          sm:grid-cols-2
          xs:grid-cols-1
          lg:auto-rows-[45vh]
          md:auto-rows-max
          xs:auto-rows-min
          gap-2"
      >
        <%= for image <- @images do %>
          <div
            x-data="{ hidden: true, open: false, title: document.title }"
            id={"image-#{image.slug}"}
            class={"#{calc_span(image.image_metadata)} relative bg-slate-300 rounded"}
          >
            <a
              phx-click="show_images"
              phx-value-slug={image.slug}
              phx-value-tags={image.tags}
              phx-value-title={image.title}
              phx-target={@myself}
              x-on:click.prevent
              x-on:click={
                  "open = !open;
                  window.history.replaceState({}, '', '#{Routes.image_show_path(@socket, :show, Nappy.slug_link(image))}');
                  document.title = \"#{image.title}#{Nappy.default_title_suffix()}\"";
                }
              class="relative"
              href={Routes.image_show_path(@socket, :show, Nappy.slug_link(image))}
              title={image.title}
            >
              <div
                x-on:mouseenter="hidden = false"
                x-on:mouseleave="hidden = true;"
                x-bind:style="hidden ? '' : 'background: linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 20%);'"
                class="w-full h-full absolute rounded"
              >
              </div>
              <img
                loading="lazy"
                class="object-cover w-full h-full rounded"
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
              x-on:keydown.escape.prevent.stop={"
                  open = false;
                  window.history.replaceState({}, '', '#{@current_url}');
                  document.title = title;
                "}
              role="dialog"
              aria-modal="true"
              x-id={"['modal-#{image.slug}']"}
              x-bind:aria-labelledby={"$id('modal-#{image.slug}')"}
              class="fixed inset-0 z-10 overflow-y-auto rounded"
            >
              <div x-show="open" x-transition.opacity class="fixed inset-0 bg-black bg-opacity-50">
              </div>
              <div
                x-show="open"
                x-transition
                x-on:click={"open = false; window.history.replaceState({}, '', '#{@current_url}'); document.title = title;"}
                class="relative flex items-center justify-center md:p-12 xs:p-2"
              >
                <button
                  x-on:click={"open = false; window.history.replaceState({}, '', '#{@current_url}')"}
                  type="button"
                  class="close-popup-button inline-flex md:text-white xs:text-black absolute md:left-4 xs:right-4 top-4 flex flex-shrink-0 bg-border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 z-50"
                >
                  <svg
                    aria-hidden
                    class="md:h-10 md:w-10 xs:h-6 xs:w-6"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                  >
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
                  class="relative overflow-y-auto rounded bg-white sm:p-8 xs:p-4 shadow-lg"
                >
                  <div class="flex justify-between xs:flex-col sm:flex-row xs:gap-4 sm:gap-2 md:gap-0">
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
                      class="object-cover md:h-[75vh] sm:w-auto xs:h-auto xs:w-full"
                      src={Catalog.image_url(image)}
                      alt={image.title}
                    />
                  </div>

                  <div class="flex md:gap-8 sm:gap-4 xs:gap-2 sm:justify-center xs:justify-between">
                    <span class="text-center p-0 m-0 flex sm:flex-row xs:flex-col sm:justify-center xs:justify-between items-center gap-2">
                      <i class="fa-solid fa-eye"></i>
                      <%= get_metrics(image).view_count %> Views
                    </span>
                    <!--
                      <span>
                        <i class="fa-solid fa-heart"></i> 23 Saves
                      </span>
                      -->
                    <span class="text-center p-0 m-0 flex sm:flex-row xs:flex-col sm:justify-center xs:justify-between items-center gap-2">
                      <i class="fa-solid fa-download"></i>
                      <%= get_metrics(image).download_count %> Downloads
                    </span>
                    <.live_component
                      module={MoreInfoComponent}
                      id={"more-info-#{image.slug}"}
                      image={image}
                      tags={Catalog.image_tags_as_list(image.tags, image.generated_tags)}
                    />
                  </div>

                  <.live_component
                    module={RelatedImagesComponent}
                    id={"related-image-#{image.slug}"}
                    related_images={@related_images}
                  />
                  <.live_component
                    :if={length(@sponsored_images) > 1}
                    module={SponsoredImagesComponent}
                    id={"sponsored-image-#{image.slug}"}
                    sponsored_images={@sponsored_images}
                  />
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
      <div id="infinite-scroll-marker" phx-hook="InfiniteScroll" data-page={@page}></div>
      <div class="mt-8 text-center text-sm">
        Looking for something specific?
        <a target="_blank" rel="noreferer noopener" class="underline" href="https://nappy.kampsite.co">
          Request a photo
        </a>
      </div>
    </div>
    """
  end

  defp calc_span(metadata) do
    ratio = Float.floor(metadata.width / metadata.height, 2)

    cond do
      ratio <= 0.79 -> "row-span-2"
      ratio === 1.0 -> "row-span-1"
      true -> "row-span-1"
    end
  end

  def related_images(slug) do
    Catalog.get_related_images(slug)
  end

  def get_metrics(image) do
    view_count = Metrics.translate_units(image.image_analytics.view_count)
    download_count = Metrics.translate_units(image.image_analytics.download_count)

    %{
      view_count: view_count,
      download_count: download_count
    }
  end
end
