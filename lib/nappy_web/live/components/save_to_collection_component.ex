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
          class="relative flex min-h-screen items-center justify-center p-4"
        >
          <div
            x-on:click.stop
            x-trap.noscroll.inert="open"
            class="relative overflow-y-auto rounded-xl bg-white p-12 shadow-lg"
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
            <h2 class="text-xl font-bold" x-bind:id="$id('modal-title')">Add to collection</h2>
            <!-- Content -->
            <fieldset class="mt-4">
              <legend class="sr-only">Add to collection</legend>
              <div class="space-y-2">
                <div
                  :for={coll_desc <- Catalog.get_collection_description_by_user_id(@current_user.id)}
                  class="relative flex items-center justify-between"
                >
                  <div class="flex h-6 items-center">
                    <input
                      id={coll_desc.slug}
                      aria-describedby={coll_desc.title}
                      name="collection_description"
                      type="radio"
                      class="h-4 w-4 border-gray-300 text-gray-600 focus:ring-gray-600"
                    />
                    <div class="ml-3 leading-6">
                      <label for={coll_desc.slug} class="font-medium text-gray-900">
                        <%= coll_desc.title %>
                      </label>
                    </div>
                  </div>
                  <!-- Toggle -->
                  <div
                    x-data="{ value: false }"
                    class="flex items-center justify-center"
                    x-id="['toggle-label']"
                  >
                    <input type="hidden" name="sendNotifications" x-bind:value="value" />
                    <!-- Button -->
                    <button
                      x-ref="toggle"
                      @click="value = ! value"
                      type="button"
                      role="switch"
                      x-bind:aria-checked="value"
                      x-bind:aria-labelledby="$id('toggle-label')"
                      x-bind:class="value ? 'bg-slate-400' : 'bg-slate-300'"
                      class="relative ml-4 inline-flex w-14 rounded-full py-1 transition"
                    >
                      <span
                        x-bind:class="value ? 'translate-x-7' : 'translate-x-1'"
                        class="bg-white h-6 w-6 rounded-full transition shadow-md"
                        aria-hidden="true"
                      >
                      </span>
                    </button>
                  </div>
                </div>
              </div>
            </fieldset>
            <!-- Buttons -->
            <div class="mt-8 flex space-x-2">
              <button
                type="button"
                x-on:click="open = false"
                class="rounded-md border border-gray-200 bg-white px-5 py-2.5"
              >
                Update
              </button>

              <button
                type="button"
                x-on:click="open = false"
                class="rounded-md border border-gray-200 bg-white px-5 py-2.5"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
