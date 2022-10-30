defmodule NappyWeb.PopularSearchesLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Catalog

  @moduledoc false

  def mount(_params, _session, socket) do
    images = Catalog.get_popular_searches()

    socket =
      socket
      |> assign(images: images)

    {:ok, socket}
  end

  def get_first_tag(tags) do
    tags
    |> String.split(",")
    |> hd()
  end
end
