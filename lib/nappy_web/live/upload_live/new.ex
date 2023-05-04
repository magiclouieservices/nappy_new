defmodule NappyWeb.UploadLive.New do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Admin
  alias Nappy.Catalog
  alias NappyWeb.Components.Admin.MultiTagSelect

  @impl true
  def mount(_params, session, socket) do
    socket =
      case session do
        %{"user_token" => user_token} ->
          assign_new(socket, :current_user, fn ->
            Accounts.get_user_by_session_token(user_token)
          end)

        %{} ->
          assign_new(socket, :current_user, fn -> nil end)
      end

    {:ok,
     socket
     |> assign(tags: [])
     |> assign(uploaded_files: [])
     |> allow_upload(:images, accept: ~w(.png .jpeg .jpg), max_entries: 1)}
  end

  @impl true
  def handle_event("save", %{"category" => category, "title" => title}, socket) do
    tags =
      socket.assigns[:tags]
      |> Enum.slice(0..Admin.max_tag_count())
      |> Enum.join(",")

    uploaded_files =
      consume_uploaded_entries(socket, :images, fn %{path: path}, entry ->
        params = %{
          category: category,
          file: entry,
          tags: tags,
          title: title,
          path: path,
          user_id: socket.assigns.current_user.id
        }

        [image] = Catalog.single_upload(Nappy.bucket_name(), params)

        {:ok, image}
      end)

    socket =
      socket
      |> assign(:tags, [])
      |> put_flash(:info, "Photo currently in pending, we'll notify you once approved.")

    Process.send_after(self(), :clear_info, 5_000)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("add_tag", tag, socket) do
    tag =
      tag
      |> String.replace(~r/[^a-zA-Z0-9\s]/, "")
      |> String.replace(~r/\W+/, "")
      |> String.split()
      |> Enum.join(" ")

    tags = [tag | socket.assigns.tags] |> Enum.uniq()
    socket = assign(socket, :tags, tags)
    {:noreply, socket}
  end

  @impl true
  def handle_event("remove_tag", %{"tag" => tag} = _params, socket) do
    send(self(), {:remove_tag, tag})
    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
