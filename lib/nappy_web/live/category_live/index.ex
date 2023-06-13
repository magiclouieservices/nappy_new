defmodule NappyWeb.CategoryLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics

  @impl true
  def mount(_params, _session, socket) do
    categories = Catalog.list_categories()
    related_tags = Catalog.random_tags(10)
    page_title = "Categories"

    seo = %{
      title: page_title,
      description: "Photos tagged according to their categories.",
      url: Routes.category_index_url(socket, :index)
    }

    socket =
      socket
      |> assign(categories: categories)
      |> assign(related_tags: related_tags)
      |> assign(page_title: page_title)
      |> SEO.assign(seo)

    {:ok, socket}
  end

  def calc_span(image_id) do
    metadata = Metrics.get_metadata_by_image_id(image_id)
    ratio = Float.floor(metadata.width / metadata.height, 2)

    cond do
      ratio <= 0.79 -> "row-span-2"
      ratio === 1.0 -> "row-span-1"
      true -> "row-span-1"
    end
  end
end
