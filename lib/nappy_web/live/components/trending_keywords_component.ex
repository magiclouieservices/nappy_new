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
    ~H"""
    <div class="flex gap-2 text-lg">
      Trending:
      <ul :for={keyword <- keywords(3)} class="text-slate-300 flex gap-2 justify-center items-center">
        <li>
          <a
            class="hover:underline hover:text-slate-100"
            href={Routes.search_show_path(@socket, :show, keyword)}
          >
            <%= keyword %>,
          </a>
        </li>
      </ul>
      <a href={Routes.popular_searches_show_path(@socket, :show)}>
        <i class="fa-solid fa-ellipsis hover:bg-gray-300 hover:text-slate-900 text-white p-1 bg-gray-600 rounded-full">
        </i>
      </a>
    </div>
    """
  end

  defp keywords(num) do
    Catalog.get_popular_keywords(num)
  end
end
