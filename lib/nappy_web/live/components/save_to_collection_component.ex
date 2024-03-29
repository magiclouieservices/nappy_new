defmodule NappyWeb.Components.SaveToCollectionComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog

  @moduledoc false

  @doc """
  Live component for dropdown "more info".

  ## Examples

    <.live_component
      module={SaveToCollectionComponent}
      id="save-to-collection-component"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }" class="inline-flex justify-center">
      <!-- Trigger -->
      <button
        x-on:click="open = true"
        type="button"
        class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
      >
        <i class="fa-solid fa-plus"></i>
      </button>
      <!-- Modal -->
      <div
        x-show="open"
        style="display: none"
        x-on:keydown.escape.prevent.stop="open = false"
        role="dialog"
        aria-modal="true"
        x-id="['modal-title']"
        x-bind:aria-labelledby="$id('modal-title')"
        class="fixed inset-0 z-10 overflow-y-auto"
      >
        <!-- Overlay -->
        <div x-show="open" x-transition.opacity class="fixed inset-0 bg-black bg-opacity-50"></div>
        <!-- Panel -->
        <div
          x-show="open"
          x-transition
          x-on:click="open = false"
          class="relative flex min-h-screen items-center justify-center pt-4"
        >
          <div
            x-on:click.stop
            x-trap.noscroll.inert="open"
            class="relative overflow-y-auto rounded-xl bg-white py-8 px-12 shadow-lg"
          >
            <div x-on:click="open = false" class="absolute right-0 top-0 hidden pr-4 pt-4 sm:block">
              <button
                type="button"
                class="rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
              >
                <span class="sr-only">Close</span>
                <svg
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <!-- Title -->
            <h2 class="text-xl font-bold" x-bind:id="$id('modal-title')">Move to collection</h2>
            <!-- Content -->
            <.form for={%{}} as={:set_collection} phx-submit="set_collection">
              <input type="hidden" name="image_slug" value={@image.slug} />
              <fieldset class="my-2 flex flex-col">
                <legend class="sr-only">Add to collection</legend>
                <%= for collection <- Catalog.get_collection_by_user_id(@current_user.id) do %>
                  <div class="relative flex items-start">
                    <div class="flex h-6 items-center">
                      <input
                        id={"#{collection.slug}#{@image.slug}"}
                        aria-describedby={collection.title}
                        name={collection.slug}
                        type="checkbox"
                        checked={
                          if @image.id == match_image_id(collection.id, @image.id),
                            do: "true",
                            else: nil
                        }
                        class="h-4 w-4 border-gray-300 text-gray-600 focus:ring-gray-600"
                      />
                    </div>
                    <div class="text-sm leading-6">
                      <label
                        for={"#{collection.slug}#{@image.slug}"}
                        class="px-3 font-medium text-gray-900"
                      >
                        <%= collection.title %>
                      </label>
                    </div>
                  </div>
                <% end %>
              </fieldset>
              <div x-on:click="open = false">
                <button
                  id={"set_collection-#{@image.slug}"}
                  type="submit"
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-4 py-1.5"
                >
                  Set collection
                </button>
              </div>
            </.form>

            <hr class="mt-12 mb-2" />
            <.form
              for={%{}}
              as={:new_collection}
              phx-submit="new_collection"
              class="flex justify-center items-center gap-2"
            >
              <input type="hidden" name="image_slug" value={@image.slug} />
              <input
                id={"input-new_collection-#{@image.slug}"}
                type="text"
                name="collection_title"
                class="inline rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-gray-600 sm:leading-6"
                placeholder="or create new collection"
              />
              <div class="inline" x-on:click="open = false">
                <button
                  id={"new_collection-#{@image.slug}"}
                  type="submit"
                  class="rounded-md text-white bg-gray-500 px-4 py-1.5"
                  disabled
                >
                  Create
                </button>
              </div>
            </.form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp match_image_id(collection_id, image_id) do
    image = Catalog.get_matched_collection(collection_id, image_id)

    if Enum.empty?(image.collections) do
      false
    else
      image.id
    end
  end
end
