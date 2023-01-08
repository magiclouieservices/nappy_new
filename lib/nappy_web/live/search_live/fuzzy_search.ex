defmodule NappyWeb.SearchLive.FuzzySearch do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Search

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [images: []]}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    search
    |> Search.changeset()
    |> case do
      %{valid?: true, changes: %{search_phrase: search_phrase}} ->
        # images = Search.search_image(search_phrase)
        images =
          Catalog.Images
          |> Search.run(search_phrase)
          |> Nappy.Repo.all()

        {:noreply, assign(socket, images: images)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("search", %{"search_phrase" => search_phrase}, socket)
      when search_phrase == "" do
    socket =
      socket
      |> assign(images: [])

    {:noreply, socket}
  end
end
