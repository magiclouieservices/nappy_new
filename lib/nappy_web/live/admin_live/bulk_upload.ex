defmodule NappyWeb.AdminLive.BulkUpload do
  use NappyWeb, :live_view

  alias NappyWeb.Components.Admin.Component

  @admin_path "/admin"

  @impl true
  def handle_params(_params, uri, socket) do
    path =
      uri
      |> URI.parse()
      |> Map.get(:path)
      |> Path.relative_to(@admin_path)
      |> String.capitalize()

    socket =
      socket
      |> assign(path: path)

    {:noreply, socket}
  end
end
