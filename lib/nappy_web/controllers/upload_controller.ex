defmodule NappyWeb.UploadController do
  use NappyWeb, :controller

  alias ExAws.S3
  alias Nappy.Admin.Slug
  alias Nappy.{Catalog, Metrics}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def bulk_new(conn, _params) do
    render(conn, "bulk_new.html")
  end

  def create(conn, params) do
    file = params["photo_file"]

    upload = fn {slug, [src_path, dest_path]} ->
      request =
        src_path
        |> S3.Upload.stream_file()
        |> S3.upload(Nappy.bucket_name(), dest_path)
        |> ExAws.request()

      with {:ok, _} <- request do
        image_status_id = Metrics.get_image_status_id(:pending)
        category_id = Catalog.get_category_by_name(params["photo_category"])
        title = params["photo_title"]
        user_id = conn.assigns.current_user.id

        tags =
          params["input-tags"]
          |> Jason.decode!()
          |> Enum.map_join(",", fn %{"value" => tag} -> tag end)

        attrs = %{
          image_status_id: image_status_id,
          category_id: category_id,
          slug: slug,
          tags: tags,
          title: title,
          user_id: user_id
        }

        Catalog.create_image(attrs)
      end
    end

    file_extension = Path.extname(file.filename)
    slug = Slug.random_alphanumeric()
    dest_path = "photos/#{slug}#{file_extension}"
    path = Map.put(%{}, slug, [file.path, dest_path])

    path
    |> Task.async_stream(upload, max_concurrency: 10, timeout: 600_000)
    |> Stream.run()

    conn
    |> put_flash(:info, "Photo currently in pending, we'll notify you once approved.")
    |> redirect(to: "/upload")

    # |> redirect(to: "/photos/#{slug}")
  end

  def bulk_create(conn, params) do
    file = params["photo_file"]

    bulk_upload = fn {slug, [src_path, dest_path]} ->
      request =
        src_path
        |> S3.Upload.stream_file()
        |> S3.upload(Nappy.bucket_name(), dest_path)
        |> ExAws.request()

      with {:ok, _} <- request do
        image_status_id = Metrics.get_image_status_id(:pending)
        category_id = Catalog.get_category_by_name(params["photo_category"])
        tags = params["photo_tags"]
        title = params["photo_title"]
        user_id = conn.assigns.current_user.id

        attrs = %{
          image_status_id: image_status_id,
          category_id: category_id,
          slug: slug,
          tags: tags,
          title: title,
          user_id: user_id
        }

        Catalog.create_image(attrs)
      end
    end

    paths =
      Enum.reduce(file, %{}, fn f, acc ->
        slug = Slug.random_alphanumeric()
        file_extension = Path.extname(f.filename)
        src_path = f.path
        dest_path = "photos/#{slug}#{file_extension}"
        Map.put(acc, slug, [src_path, dest_path])
      end)

    paths
    |> Task.async_stream(bulk_upload, max_concurrency: 10, timeout: 600_000)
    |> Stream.run()

    conn
    |> put_flash(:info, "Photo currently in pending, we'll notify you once approved.")
    |> redirect(to: "/bulk-upload")
  end
end
