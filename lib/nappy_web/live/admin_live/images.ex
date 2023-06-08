defmodule NappyWeb.AdminLive.Images do
  use NappyWeb, :live_view

  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.Search
  alias NappyWeb.Components.Admin.Component
  alias NappyWeb.Components.Admin.ImagesApprovalButtonComponent
  alias NappyWeb.Components.Admin.ImagesFilterImageStatusComponent
  alias NappyWeb.Components.Admin.ImagesPaginationComponent
  alias NappyWeb.Components.Admin.SearchComponent

  @admin_path "/admin"

  @impl true
  def handle_params(params, uri, socket) do
    page = (params["page"] || "1") |> String.to_integer()
    sort_by = (params["sort_by"] || "inserted_at") |> String.to_existing_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_existing_atom()
    page_title = "Admin: photos section"
    search_phrase = params["search_phrase"] || ""
    image_status = (params["image_status"] || "all") |> String.to_existing_atom()

    path =
      uri
      |> URI.parse()
      |> Map.get(:path)
      |> Path.relative_to(@admin_path)
      |> String.capitalize()

    socket =
      socket
      |> assign(path: path)
      |> assign(page: page)
      |> assign(redirect_url: uri)
      |> assign(page_title: page_title)
      |> assign(sort_by: sort_by)
      |> assign(sort_order: sort_order)
      |> assign(search_phrase: search_phrase)
      |> assign(image_status: image_status)

    socket =
      if search_phrase === "" do
        socket
        |> fetch()
      else
        params = [
          page: page,
          sort_order: sort_order,
          image_status: image_status
        ]

        images = Search.paginate_admin_search(search_phrase, params)

        socket
        |> assign(images: images)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_photo", params, socket) do
    Catalog.admin_update_image(params)

    socket =
      socket
      |> put_flash(:info, "updated an image")

    Process.send_after(self(), :clear_info, 5_000)

    path = Routes.admin_images_path(socket, :images)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event("sort_image", params, socket) do
    sort_order =
      if params["sort_order"] === "desc" do
        :asc
      else
        :desc
      end

    params = [
      page: params["page"],
      sort_by: String.to_existing_atom(params["sort_by"]),
      sort_order: sort_order,
      search_phrase: socket.assigns.search_phrase,
      image_status: params["image_status"]
    ]

    path = Routes.admin_images_path(socket, :images, params)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event(
        "filter_by_image_status",
        %{"image_status" => image_status},
        %{assigns: assigns} = socket
      ) do
    params = [
      page: assigns.page,
      sort_by: assigns.sort_by,
      sort_order: assigns.sort_order,
      search_phrase: assigns.search_phrase,
      image_status: image_status
    ]

    path = Routes.admin_images_path(socket, :images, params)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event("next", _params, %{assigns: assigns} = socket) do
    params = [
      page: assigns.page + 1,
      sort_by: assigns.sort_by,
      sort_order: assigns.sort_order,
      search_phrase: assigns.search_phrase,
      image_status: assigns.image_status
    ]

    path = Routes.admin_images_path(socket, :images, params)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event("prev", _params, %{assigns: assigns} = socket) do
    params = [
      page: assigns.page - 1,
      sort_by: assigns.sort_by,
      sort_order: assigns.sort_order,
      search_phrase: assigns.search_phrase,
      image_status: assigns.image_status
    ]

    path = Routes.admin_images_path(socket, :images, params)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end

  defp fetch(%{assigns: assigns} = socket) do
    params = [
      page: assigns.page,
      sort_by: assigns.sort_by,
      sort_order: assigns.sort_order,
      search_phrase: assigns.search_phrase,
      image_status: assigns.image_status
    ]

    images = Catalog.paginate_images(:admin, params)

    assign(socket, images: images)
  end

  def ellipsis(string) do
    if String.length(string) > 20,
      do: "#{String.slice(string, 0..20)}...",
      else: string
  end
end
