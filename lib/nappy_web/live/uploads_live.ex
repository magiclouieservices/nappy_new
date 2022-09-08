defmodule NappyWeb.UploadsLive do
  use NappyWeb, :live_view

  alias ExAws.S3
  alias Nappy.Admin.Slug
  # alias NappyWeb.Uploaders.Avatar

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     # |> allow_upload(:exhibit, accept: ~w(video/* image/*), max_entries: 6, chunk_size: 64_000)}
     |> allow_upload(
       :single_photo,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 10,
       max_file_size: 100_000_000
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :single_photo, ref)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    # photo_title = params["upload_form"]["photo_title"]
    # IO.inspect(socket, label: "socket")

    uploaded_files =
      consume_uploaded_entries(socket, :single_photo, fn %{path: path}, entry ->
        filename = entry.client_name
        # IO.inspect(entry.client_name, label: "file name")
        # IO.inspect(path, label: "path")

        # {:ok, image} = Image.open("my_file.jpg")
        # x = Enum.random(0..(Image.width(image) - 1))
        # y = Enum.random(0..(Image.height(image) - 1))
        # {:ok, pixel} = Image.get_pixel(image, x, y)
        # [95.0, 59.0, 35.0]
        # pixel
        # |> Enum.map(pixel, fn val ->
        #   val
        #   |> Float.round()
        #   |> Integer.to_string(16)
        # end)
        # |> Enum.join("")
        # file_extension = Path.extname(path)

        # rgb convert to hex
        # Integer.to_string(value, 16)

        # {:ok, image} = Image.open("image/path/to/file.jpg")
        # {:ok, exif} = Image.exif(image)
        # {:ok, avatar} = Image.resize(image, 200)
        # stream = File.stream!("priv/avatar.jpg")
        # Image.write(avatar, stream, suffix: ".jpg")

        # file_extension = Path.extname(filename)
        # slug = Slug.random_alphanumeric()

        # path
        # |> S3.Upload.stream_file()
        # # |> S3.upload(Nappy.bucket_name(), "photos/pending/photo.jpg")
        # |> S3.upload("nappy-prod", "photos/pending/#{slug}#{file_extension}")
        # |> ExAws.request!()

        # dest = Path.join(Nappy.uploads_priv_dir(), "#{slug}#{file_extension}")
        # File.cp!(path, dest)
        # Routes.static_path(socket, "priv/#{slug}#{file_extension}")
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end
end
