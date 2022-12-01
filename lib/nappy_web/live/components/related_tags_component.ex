defmodule NappyWeb.Components.RelatedTagsComponent do
  use NappyWeb, :live_component

  @moduledoc false

  @doc """
  Live component for dropdown "more info".

  ## Examples

    <.live_component
    module={RelatedTagsComponent}
    id="related-tags"
    related_tags={@related_tags}
    />
  """
  def render(assigns) do
    ~H"""
    <div>
      <p class="mt-8 mb-4 font-tiempos-bold text-center text-2xl">Related Tags</p>
      <ul class="mx-auto md:w-96 xs:w-auto flex flex-wrap justify-center gap-2">
        <%= for related_tag <- @related_tags do %>
          <a
            rel="nofollow noreferer"
            href={Routes.search_show_path(@socket, :show, related_tag)}
            class="inline-flex items-center px-2 py-1 border border-gray-300 rounded-md text-gray-500 font-light text-sm bg-white hover:bg-black hover:underline hover:text-white focus:outline-none"
          >
            <li><%= related_tag %></li>
          </a>
        <% end %>
      </ul>
    </div>
    """
  end
end
