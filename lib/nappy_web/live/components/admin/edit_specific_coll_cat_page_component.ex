defmodule NappyWeb.Components.Admin.EditSpecificCollCatPageComponent do
  use NappyWeb, :live_component

  @moduledoc false

  # TODO: edit, delete, change thumbnail, set related tags and description

  @impl true
  def handle_event("delete_collection", %{"slug" => slug}, socket) do
    IO.inspect(socket.assigns, label: "assigns")

    socket =
      socket
      |> put_flash(:info, "deleted collection")

    path = Routes.collections_show_path(socket, :show, slug)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @doc """
  Add/update/delete button for a specific collection
  or categories page.

  ## Examples

    <.live_component
      module={EditSpecificCollCatPageComponent}
      id="edit-collections-page-admin"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      
      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <span x-on:click="open = true">
          <button
            type="button"
            class="inline-flex items-center gap-x-1.5 rounded-md bg-sky-700 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-sky-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-700"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125"
              />
            </svg>
            Edit
          </button>
        </span>
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

      <button
        phx-click="delete_collection"
        phx-value-slug={@slug}
        phx-target={@myself}
        type="button"
        class="inline-flex items-center gap-x-1.5 rounded-md bg-red-700 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-red-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-700"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-4 h-4"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
          />
        </svg>
        Delete
      </button>

      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <span x-on:click="open = true">
          <button
            type="button"
            class="inline-flex items-center gap-x-1.5 rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-black shadow-sm hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gray-600"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"
              />
            </svg>
            Change thumbnail
          </button>
        </span>
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

      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <span x-on:click="open = true">
          <button
            type="button"
            class="inline-flex items-center gap-x-1.5 rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-black shadow-sm hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gray-600"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z"
              />
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 6h.008v.008H6V6z" />
            </svg>
            Set related tags
          </button>
        </span>
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

      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <span x-on:click="open = true">
          <button
            type="button"
            class="inline-flex items-center gap-x-1.5 rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-black shadow-sm hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gray-600"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25H12"
              />
            </svg>
            Set description
          </button>
        </span>
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
    </div>
    """
  end
end
