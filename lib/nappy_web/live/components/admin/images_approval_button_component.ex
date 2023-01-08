defmodule NappyWeb.Components.Admin.ImagesApprovalButtonComponent do
  use NappyWeb, :live_component

  alias Nappy.Catalog
  alias Nappy.Metrics

  @moduledoc false

  @impl true
  def handle_event("approve_images", params, socket) do
    params
    |> Map.values()
    |> Metrics.approve_images()

    socket =
      socket
      |> put_flash(:info, "approved selected images")

    path = Routes.admin_images_path(socket, :images)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event("deny_images", params, socket) do
    params
    |> Map.values()
    |> Metrics.deny_images()

    socket =
      socket
      |> put_flash(:info, "denied selected images")

    path = Routes.admin_images_path(socket, :images)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @impl true
  def handle_event("delete_images", params, socket) do
    params
    |> Map.values()
    |> Catalog.delete_multiple_images()

    socket =
      socket
      |> put_flash(:info, "deleted selected images")

    path = Routes.admin_images_path(socket, :images)

    {:noreply, push_navigate(socket, to: path, replace: true)}
  end

  @doc """
  Approval button for /admin/images.

  ## Examples

    <.live_component
      module={ImagesApprovalButtonComponent}
      id="admin-images-approval"
    />
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center gap-2 bg-gray-50 sm:left-16">
      <form
        :for={
          {action, button_class_name, icon_name} <-
            [
              {"Approve", "border-green-800 bg-green-600 hover:bg-green-700 focus:ring-green-700",
               "fa-check"},
              {"Deny", "border-yellow-800 bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-700",
               "fa-hand"},
              {"Delete", "border-red-800 bg-red-700 hover:bg-red-700 focus:ring-red-700", "fa-trash"}
            ]
        }
        phx-submit={"#{String.downcase(action)}_images"}
        phx-target={@myself}
        method="GET"
        id={"form-#{String.downcase(action)}"}
      >
        <button
          type="submit"
          phx-submit={"#{String.downcase(action)}_images"}
          phx-target={@myself}
          class={"#{button_class_name} flex gap-1 items-center rounded border px-2 py-1 text-sm font-medium text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-30"}
        >
          <i class={"fa-solid #{icon_name}"}></i>
          <%= action %>
        </button>
      </form>
    </div>
    """
  end
end
