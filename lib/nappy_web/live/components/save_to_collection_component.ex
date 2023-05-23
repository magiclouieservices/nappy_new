defmodule NappyWeb.Components.SaveToCollectionComponent do
  use NappyWeb, :live_component

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
            class="relative w-full max-w-2xl overflow-y-auto rounded-xl bg-white p-12 shadow-lg"
          >
            <!-- Title -->
            <h2 class="text-3xl font-bold" x-bind:id="$id('modal-title')">Confirm</h2>
            <!-- Content -->
            <p class="mt-2 text-gray-600">
              Are you sure you want to learn how to create an awesome modal?
            </p>
            <!-- Buttons -->
            <div class="mt-8 flex space-x-2">
              <button
                type="button"
                x-on:click="open = false"
                class="rounded-md border border-gray-200 bg-white px-5 py-2.5"
              >
                Confirm
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
