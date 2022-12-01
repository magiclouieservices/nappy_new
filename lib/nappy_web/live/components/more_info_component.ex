defmodule NappyWeb.Components.MoreInfoComponent do
  use NappyWeb, :live_component

  @moduledoc false

  @doc """
  Live component for dropdown "more info".

  ## Examples

    <.live_component
    module={MoreInfoComponent}
    id="more-info"
    images={@image}
    tags={Catalog.image_tags_as_list(@image.tags, @image.generated_tags)}
    />
  """
  def render(assigns) do
    ~H"""
    <span
      x-data="{open: false,
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
      class="relative xs:flex xs:justify-center"
    >
      <!-- Button -->
      <button
        x-ref="button"
        x-on:click="toggle()"
        x-bind:aria-expanded="open"
        x-bind:aria-controls="$id('dropdown-button')"
        type="button"
        class="flex xs:flex-col sm:flex-row gap-2 xs:justify-between xs:items-center"
      >
        <i class="fa-solid fa-circle-info"></i>
        <span>More info</span>
      </button>
      <!-- Panel -->
      <div
        x-ref="panel"
        x-show="open"
        x-transition.origin.top.left
        x-on:click.outside="close($refs.button)"
        x-bind:id="$id('dropdown-button')"
        style="display: none;"
        class="absolute z-10 xs:w-72 sm:w-[420px] right-0 mt-2 py-2 px-4 bg-black text-white rounded"
      >
        <p class="my-2">Title: <%= @image.title %></p>
        <p class="mt-2">Tags:</p>
        <%= for tag <- @tags do %>
          <a
            target="_blank"
            rel="noreferer noopener"
            href={Routes.search_show_path(@socket, :show, tag)}
            class="inline-block m-0.5 px-1.5 py-0.5 rounded-full border border-white hover:underline"
          >
            <%= tag %>
          </a>
        <% end %>
        <hr class="mt-4 mb-2 bg-white" />
        <i class="fa-brands fa-creative-commons-zero"></i>
        public domain
      </div>
    </span>
    """
  end
end
