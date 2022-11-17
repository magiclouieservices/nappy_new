defmodule NappyWeb.CategoryLive.Index do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  # alias Plug.Conn.Status

  @impl true
  def mount(_params, _session, socket) do
    categories = Catalog.list_categories()
    related_tags = Catalog.random_tags(10)

    socket =
      socket
      |> assign(categories: categories)
      |> assign(related_tags: related_tags)

    {:ok, socket}
  end
end
