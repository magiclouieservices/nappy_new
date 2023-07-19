defmodule NappyWeb.Components.TrendingKeywordsComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog

  @moduledoc false

  @doc """
  Trending keywords component

  ## Examples

    <.live_component
      module={TrendingKeywordsComponent}
      id="trending-keywords"
      class="flex gap-2 text-lg"
    />
  """
  def render(assigns) do
    keywords = Catalog.get_popular_keywords(3)

    ~H"""
    <div class="flex gap-2 md:text-lg xs:gap-1 xs:text-base">
      Trending:
      <ul :for={keyword <- keywords} class="text-slate-300 flex gap-2 justify-center items-center">
        <li>
          <a
            class="hover:underline hover:text-slate-100"
            href={Routes.search_show_path(@socket, :show, keyword)}
          >
            <%= keyword %><%= if List.last(keywords) !== keyword, do: "," %>
          </a>
        </li>
      </ul>
    </div>
    """
  end
end
