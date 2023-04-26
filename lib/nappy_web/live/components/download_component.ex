defmodule NappyWeb.Components.DownloadComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog
  alias Nappy.Catalog.Images

  @moduledoc false

  @doc """
  Live component for downloading an image.

  ## Examples

    <.live_component
    module={DownloadComponent}
    id="download-component"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div
        x-data="{
                open: false,
                toggle() {
                    if (this.open) {
                        return this.close()
                    }

                    this.$refs.button.focus()

                    this.open = true
                },
                close(focusAfter) {
                    if (! this.open) return

                    this.open = false

                    focusAfter && focusAfter.focus()
                }
            }"
        x-on:keydown.escape.prevent.stop="close($refs.button)"
        x-on:focusin.window="! $refs.panel.contains($event.target) && close()"
        x-id="['dropdown-button']"
        class="relative"
      >
        <!-- Button -->
        <button
          x-ref="button"
          x-on:click="toggle()"
          x-bind:aria-expanded="open"
          x-bind:aria-controls="$id('dropdown-button')"
          type="button"
          class="inline-flex gap-2 justify-center items-center rounded-md bg-green-600 px-4 h-8 text-xs text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
        >
          <span>Download</span>
          <!-- Heroicon: chevron-down -->
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-white"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
        <!-- Panel -->
        <div
          x-ref="panel"
          x-show="open"
          x-transition.origin.top.left
          x-on:click.outside="close($refs.button)"
          x-bind:id="$id('dropdown-button')"
          style="display: none;"
          class="mt-2 rounded-md bg-white shadow-md"
          id="download-file-hook"
          phx-hook="DownloadFile"
        >
          <button
            id="download-small"
            value={Catalog.imgix_url(@image, "photo", %{w: 320})}
            class="flex items-center gap-2 w-full first-of-type:rounded-t-md last-of-type:rounded-b-md px-4 py-2.5 text-left text-sm hover:bg-gray-50 disabled:text-gray-500"
          >
            Small
          </button>

          <button
            id="download-medium"
            value={Catalog.imgix_url(@image, "photo", w: 600)}
            class="flex items-center gap-2 w-full first-of-type:rounded-t-md last-of-type:rounded-b-md px-4 py-2.5 text-left text-sm hover:bg-gray-50 disabled:text-gray-500"
          >
            Medium
          </button>

          <button
            id="download-large"
            value={Catalog.imgix_url(@image, "photo", w: 920)}
            class="flex items-center gap-2 w-full first-of-type:rounded-t-md last-of-type:rounded-b-md px-4 py-2.5 text-left text-sm hover:bg-gray-50 disabled:text-gray-500"
          >
            Large
          </button>

          <button
            id="download-original"
            value={
              Catalog.imgix_url(@image, "photo",
                w: @image.image_metadata.width,
                h: @image.image_metadata.height
              )
            }
            class="flex items-center gap-2 w-full first-of-type:rounded-t-md last-of-type:rounded-b-md px-4 py-2.5 text-left text-sm hover:bg-gray-50 disabled:text-gray-500"
          >
            Original
          </button>
        </div>
      </div>
    </div>
    """
  end
end
