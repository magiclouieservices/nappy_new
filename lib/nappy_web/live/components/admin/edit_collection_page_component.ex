defmodule NappyWeb.Components.Admin.EditCollectionPageComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog
  alias NappyWeb.Components.Admin.ThumbnailPickerComponent

  @moduledoc false

  @impl true
  def handle_event("disable_collection", %{"slug" => slug}, socket) do
    socket =
      socket
      |> put_flash(:info, "TODO disabled collection")

    path = Routes.collections_show_path(socket, :show, slug)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event(
        "update_collection",
        %{"collection_title" => collection_title, "is_enabled" => is_enabled, "slug" => slug},
        socket
      ) do
    attrs = %{
      is_enabled: is_enabled,
      title: collection_title,
      slug: slug
    }

    collection_description = Catalog.update_collection_description(attrs)

    socket =
      socket
      |> put_flash(:info, "Succesfully updated the collection")

    path = Routes.collections_show_path(socket, :show, collection_description.slug)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event(
        "update_thumbnail",
        %{"slug" => slug, "thumbnail" => thumbnail},
        socket
      ) do
    image = Catalog.get_image_by_slug(thumbnail)

    attrs = %{
      thumbnail: image.id,
      slug: slug
    }

    collection_description = Catalog.update_collection_description(attrs)

    socket =
      socket
      |> put_flash(:info, "Succesfully updated thumbnail")

    path = Routes.collections_show_path(socket, :show, collection_description.slug)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event("update_related_tags", %{"slug" => slug, "input-tags" => related_tags}, socket) do
    related_tags =
      related_tags
      |> Jason.decode!()
      |> Enum.map_join(",", fn %{"value" => value} -> value end)

    attrs = %{
      slug: slug,
      related_tags: related_tags
    }

    collection_description = Catalog.update_collection_description(attrs)

    socket =
      socket
      |> put_flash(:info, "Succesfully updated the related tags")

    path = Routes.collections_show_path(socket, :show, collection_description.slug)

    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event(
        "update_collection_description",
        %{"slug" => slug, "description" => description},
        socket
      ) do
    attrs = %{
      slug: slug,
      description: String.trim(description)
    }

    collection_description = Catalog.update_collection_description(attrs)

    socket =
      socket
      |> put_flash(:info, "Succesfully updated description")

    path = Routes.collections_show_path(socket, :show, collection_description.slug)

    {:noreply, push_navigate(socket, to: path)}

    # socket =
    #   socket
    #   |> put_flash(:info, "TODO update #{description} description")

    # path = Routes.collections_show_path(socket, :show, slug)

    # {:noreply, push_navigate(socket, to: path)}
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
    <div id="input-tags-hook" phx-hook="InputTags">
      <!-- Start edit button -->
      <div
        x-data={"{
          open: false,
          value: #{@collection_desc.is_enabled}
        }"}
        class="text-black inline-flex justify-center"
      >
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
          x-on:keydown.escape.prevent.stop={"open = false; value = #{@collection_desc.is_enabled}; document.getElementById('update-collection').reset()"}
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
            x-on:click={"open = false; value = #{@collection_desc.is_enabled}; document.getElementById('update-collection').reset()"}
            class="relative flex min-h-screen items-center justify-center p-4"
          >
            <div
              x-on:click.stop
              x-trap.noscroll.inert="open"
              class="relative overflow-y-auto rounded-xl bg-white p-12 shadow-lg"
            >
              <div
                x-on:click={"open = false; value = #{@collection_desc.is_enabled}; document.getElementById('update-collection').reset()"}
                class="absolute right-0 top-0 hidden pr-4 pt-4 sm:block"
              >
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
              <h2 class="text-xl font-bold" x-bind:id="$id('modal-title')">
                Edit collection name and visibility
              </h2>
              <!-- Content -->
              <div class="mt-4">
                <label for="collection-title" class="sr-only">
                  Collection Title
                </label>
                <input
                  type="text"
                  name="collection_title"
                  id="collection-title"
                  form="update-collection"
                  value={@collection_desc.title}
                  required
                  class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-gray-600 sm:leading-6 font-bold"
                />
              </div>
              <!-- Toggle -->
              <div class="my-4 flex items-center justify-center" x-id="['toggle-label']">
                <input type="hidden" name="is_enabled" x-bind:value="value" form="update-collection" />
                <input
                  type="hidden"
                  name="slug"
                  value={@collection_desc.slug}
                  form="update-collection"
                />
                <!-- Label -->
                <label
                  @click="$refs.toggle.click(); $refs.toggle.focus()"
                  x-bind:id="$id('toggle-label')"
                  class="text-gray-900 font-medium"
                >
                  Is enabled (viewed publicly)?
                </label>
                <!-- Button -->
                <button
                  x-ref="toggle"
                  x-on:click="value = ! value"
                  type="button"
                  role="switch"
                  x-bind:aria-checked="value"
                  x-bind:aria-labelledby="$id('toggle-label')"
                  x-bind:class="value ? 'bg-green-500' : 'bg-slate-300'"
                  class="relative ml-2 inline-flex w-14 rounded-full py-1 transition"
                >
                  <span
                    x-bind:class="value ? 'translate-x-7' : 'translate-x-1'"
                    class="bg-white h-6 w-6 rounded-full transition shadow-md"
                    aria-hidden="true"
                  >
                  </span>
                </button>
              </div>
              <!-- Buttons -->
              <div class="mt-4 flex space-x-2 justify-center">
                <.form
                  :let={_f}
                  for={%{}}
                  as={:update_collection}
                  id="update-collection"
                  phx-submit="update_collection"
                  phx-target={@myself}
                >
                  <button
                    phx-submit="update_collection"
                    phx-target={@myself}
                    type="submit"
                    class="rounded-md border border-gray-200 bg-white hover:bg-gray-100 px-5 py-2.5"
                  >
                    Update
                  </button>
                </.form>
                <button
                  type="button"
                  x-on:click={"open = false; value = #{@collection_desc.is_enabled}; document.getElementById('update-collection').reset()"}
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-5 py-2.5"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End edit button -->

      <!-- Start disable button -->
      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <span x-on:click="open = true">
          <button
            type="button"
            class="inline-flex items-center gap-x-1.5 rounded-md bg-gray-700 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-gray-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gray-700"
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
                d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"
              />
            </svg>
            Disable
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
              <h2 class="text-xl font-bold" x-bind:id="$id('modal-title')">
                Confirm disable
                <span class="bg-black text-white py-0.5 px-1.5 rounded">
                  <%= @collection_desc.title %>
                </span>
              </h2>
              <!-- Content -->
              <p class="mt-2 text-gray-600">
                Disabling this will not display publicly. Are you sure?
              </p>
              <!-- Buttons -->
              <div class="mt-8 flex space-x-2 justify-center">
                <.form
                  :let={_f}
                  id="confirm-disable-collection"
                  for={%{}}
                  as={:confirm_disable_collection}
                  phx-submit="disable_collection"
                  phx-target={@myself}
                >
                  <input type="hidden" name="slug" value={@slug} />
                  <button
                    phx-submit="disable_collection"
                    phx-target={@myself}
                    type="submit"
                    class="rounded-md border border-gray-200 bg-white hover:bg-gray-100 px-5 py-2.5"
                  >
                    Confirm
                  </button>
                </.form>
                <button
                  type="button"
                  x-on:click="open = false"
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-5 py-2.5"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End disable button -->

      <!-- Start change thumbnail button -->
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
              <h2 class="text-xl font-bold mb-4" x-bind:id="$id('modal-title')">
                Pick an image for thumbnail
              </h2>
              <!-- Content -->
              <.live_component
                module={ThumbnailPickerComponent}
                id="thumbnail-picker"
                slug={@slug}
                page={@collection_desc}
                page_type="collection"
              />
              <!-- Buttons -->
              <div class="mt-8 flex space-x-2 justify-center">
                <.form
                  :let={_f}
                  id="update-thumbnail"
                  for={%{}}
                  as={:update_thumbnail}
                  phx-submit="update_thumbnail"
                  phx-target={@myself}
                >
                  <input type="hidden" name="slug" value={@slug} />
                  <button
                    phx-submit="update_thumbnail"
                    phx-target={@myself}
                    type="submit"
                    class="rounded-md border border-gray-200 bg-white hover:bg-gray-100 px-5 py-2.5"
                  >
                    Set thumbnail
                  </button>
                </.form>
                <button
                  type="button"
                  x-on:click="open = false; document.getElementById('update-collection-thumbnail').reset()"
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-5 py-2.5"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End change thumbnail button -->

      <!-- Start set related tags button -->
      <div x-data="{ open: false }" class="text-black inline-flex justify-center">
        <!-- Trigger -->
        <button
          x-on:click="open = true"
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
        <!-- Modal -->
        <div
          x-show="open"
          style="display: none"
          x-on:keydown.escape={"open = false; window.resetTags('#{@collection_desc.related_tags}')"}
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
            x-on:click={"open = false; window.resetTags('#{@collection_desc.related_tags}')"}
            class="relative flex min-h-screen items-center justify-center p-4"
          >
            <div
              x-on:click.stop
              x-trap.noscroll.inert="open"
              class="relative w-full max-w-2xl overflow-y-auto rounded-xl bg-white p-12 shadow-lg"
            >
              <div
                x-on:click={"open = false; window.resetTags('#{@collection_desc.related_tags}')"}
                class="absolute right-0 top-0 hidden pr-4 pt-4 sm:block"
              >
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
              <h2 class="text-xl font-tiempos-bold" x-bind:id="$id('modal-title')">
                Set tags for "<%= @collection_desc.title %>"
              </h2>
              <!-- Content -->
              <input
                id={"input-tags-#{@collection_desc.slug}"}
                name="input-tags"
                value={@collection_desc.related_tags}
                form="confirm-update-related_tags"
                class="mt-1 appearance-none block w-full border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-gray-500 focus:border-gray-500 sm:text-sm"
              />
              <!-- Buttons -->
              <div class="mt-8 flex space-x-2 justify-center">
                <.form
                  :let={_f}
                  id="confirm-update-related_tags"
                  for={%{}}
                  as={:confirm_update_related_tags}
                  phx-target={@myself}
                >
                  <input type="hidden" name="slug" value={@slug} />
                  <button
                    id="confirm-update-related_tags-button"
                    phx-target={@myself}
                    type="submit"
                    class="rounded-md border border-gray-200 bg-white hover:bg-gray-100 px-5 py-2.5"
                  >
                    Update
                  </button>
                </.form>

                <button
                  type="button"
                  x-on:click={"open = false; window.resetTags('#{@collection_desc.related_tags}')"}
                  value={@collection_desc.related_tags}
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-5 py-2.5"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End set related tags button -->

      <!-- Start set description button -->
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
          x-on:keydown.escape.prevent.stop="open = false; document.getElementById('update-collection-description').reset()"
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
            x-on:click="open = false; document.getElementById('update-collection-description').reset()"
            class="relative flex min-h-screen items-center justify-center p-4"
          >
            <div
              x-on:click.stop
              x-trap.noscroll.inert="open"
              class="relative w-full max-w-2xl overflow-y-auto rounded-xl bg-white p-12 shadow-lg"
            >
              <div
                x-on:click="open = false; document.getElementById('update-collection-description').reset()"
                class="absolute right-0 top-0 hidden pr-4 pt-4 sm:block"
              >
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
              <h2 class="text-xl font-bold" x-bind:id="$id('modal-title')">
                Edit description
              </h2>
              <!-- Content -->
              <textarea
                rows="20"
                cols="50"
                form="update-collection-description"
                name="description"
                class="mt-1 appearance-none block w-full border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-gray-500 focus:border-gray-500 sm:text-sm"
              >
                <%= @collection_desc.description %>
              </textarea>
              <!-- Buttons -->
              <div class="mt-8 flex space-x-2 justify-center">
                <.form
                  :let={_f}
                  id="update-collection-description"
                  phx-submit="update_collection_description"
                  for={%{}}
                  as={:update_collection_description}
                  phx-target={@myself}
                >
                  <input type="hidden" name="slug" value={@slug} />
                  <button
                    phx-submit="update_collection_description"
                    phx-target={@myself}
                    type="submit"
                    class="rounded-md border border-gray-200 bg-white hover:bg-gray-100 px-5 py-2.5"
                  >
                    Update
                  </button>
                </.form>

                <button
                  type="button"
                  x-on:click="open = false; document.getElementById('update-collection-description').reset()"
                  class="rounded-md text-white bg-black hover:bg-gray-900 px-5 py-2.5"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End set description button -->
    </div>
    """
  end
end
