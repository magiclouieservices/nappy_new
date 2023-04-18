defmodule NappyWeb.Components.ShareLinkComponent do
  use NappyWeb, :live_component

  alias Nappy.Accounts

  @moduledoc false

  @doc """
  Live component for dropdown "more info".

  ## Examples

    <.live_component
    module={ShareLinkComponent}
    id="share-link"
    />
  """
  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }" class="inline-flex">
      <!-- Trigger -->
      <button
        class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
        x-on:click="open = true"
        type="button"
      >
        <i class="fa-solid fa-reply fa-flip-horizontal"></i>
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
          class="relative w-full flex min-h-screen items-center justify-center p-4"
        >
          <div
            x-on:click.stop
            x-trap.noscroll.inert="open"
            class="relative max-w-3xl overflow-y-auto rounded-lg bg-white shadow-lg"
          >
            <!-- close button -->
            <button
              x-on:click="open = false"
              class="absolute right-4 top-4 text-gray-400 hover:text-gray-700"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="4"
                stroke="currentColor"
                class="w-8 h-8"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
            <!-- end close button -->

            <!-- Content -->
            <a
              class="mt-12 text-white flex gap-2 justify-center items-center hover:underline"
              href={Routes.user_profile_show_path(@socket, :show, @user.username)}
            >
              <img
                class="rounded-full w-24 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
                src={Accounts.avatar_url(@user.avatar_link)}
              />
            </a>
            <h2 class="text-3xl text-center px-12" x-bind:id="$id('modal-title')">
              Say Thanks!
            </h2>

            <p class="text-gray-500 mx-auto text-center w-[48ch] py-3 px-12">
              Send appreciation to
              <a
                href={Routes.user_profile_show_path(@socket, :show, @user.username)}
                class="text-gray-900 hover:underline"
              >
                @<%= @user.username %>
              </a>
              by following or giving them credit.
            </p>
            <!-- End Content -->

            <!-- Follow button -->
            <button
              type="button"
              class="mx-auto rounded bg-white px-3 py-2 text text-gray-700 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-100 flex items-center justify-center gap-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="4"
                stroke="currentColor"
                class="w-5 h-5 text-gray-700"
              >
                <path d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
              Follow
            </button>
            <!-- End follow button -->

            <!-- Tab shared links -->
            <div class="bg-gray-50 mt-6 pt-4 pb-4 flex justify-center items-center">
              <!-- Tabs -->
              <div
                x-data="{
                      selectedId: null,
                      init() {
                          // Set the first available tab on the page on page load.
                          this.$nextTick(() => this.select(this.$id('tab', 1)))
                      },
                      select(id) {
                          this.selectedId = id
                      },
                      isSelected(id) {
                          return this.selectedId === id
                      },
                      whichChild(el, parent) {
                          return Array.from(parent.children).indexOf(el) + 1
                      }
                  }"
                x-id="['tab']"
                class="mx-auto max-w-3xl"
              >
                <!-- Tab List -->
                <ul
                  x-ref="tablist"
                  @keydown.right.prevent.stop="$focus.wrap().next()"
                  @keydown.home.prevent.stop="$focus.first()"
                  @keydown.page-up.prevent.stop="$focus.first()"
                  @keydown.left.prevent.stop="$focus.wrap().prev()"
                  @keydown.end.prevent.stop="$focus.last()"
                  @keydown.page-down.prevent.stop="$focus.last()"
                  role="tablist"
                  class="-mb-px flex w-72 mx-auto justify-center"
                >
                  <!-- Tab -->
                  <li :for={tab_name <- ["Share URL", "Photo Link", "Embed Link"]}>
                    <button
                      x-bind:id="$id('tab', whichChild($el.parentElement, $refs.tablist))"
                      @click="select($el.id)"
                      @mousedown.prevent
                      @focus="select($el.id)"
                      type="button"
                      x-bind:tabindex="isSelected($el.id) ? 0 : -1"
                      x-bind:aria-selected="isSelected($el.id)"
                      x-bind:class="isSelected($el.id) ? 'border-b-2 border-b-green-500 text-green-600' : 'border-b-2 border-b-gray-300'"
                      class="inline-flex px-2 py-1"
                      role="tab"
                    >
                      <%= tab_name %>
                    </button>
                  </li>
                </ul>
                <!-- Panels -->
                <div role="tabpanels" class="mt-4 px-6">
                  <!-- Panel -->
                  <section
                    :for={
                      [share_type, share_desc, share_url] <-
                        [
                          ["share_url", "Share this url", @share_url],
                          ["photo_link", "Tag this photo in your web project", @photo_link],
                          ["embed_url", "Add this source in your web project", @embed_url]
                        ]
                    }
                    x-show="isSelected($id('tab', whichChild($el, $el.parentElement)))"
                    x-bind:aria-labelledby="$id('tab', whichChild($el, $el.parentElement))"
                    role="tabpanel"
                    class="mb-2"
                  >
                    <h2 class="text-sm"><%= share_desc %></h2>
                    <div
                      id={"hook-clipboard-#{share_type}"}
                      phx-hook="Clipboard"
                      class="mt-2 rounded border border-gray-200 flex gap-2 justify-between p-2"
                    >
                      <p><%= share_url %></p>
                      <button
                        value={share_url}
                        class="copy-button bg-white px-2 py-.5 text-black font-bold rounded flex items-center justify-center border border-gray-300 hover:bg-black hover:text-white"
                      >
                        <!-- Heroicon name: outline/document-duplicate -->
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          class="w-4 h-4 mr-1"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 01-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 011.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 00-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 01-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 00-3.375-3.375h-1.5a1.125 1.125 0 01-1.125-1.125v-1.5a3.375 3.375 0 00-3.375-3.375H9.75"
                          />
                        </svg>
                        Copy
                      </button>
                    </div>
                  </section>
                </div>
              </div>
            </div>
            <!-- End tab shared links -->
          </div>
        </div>
      </div>
    </div>
    """
  end
end
