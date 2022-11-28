defmodule NappyWeb.UploadController do
  use NappyWeb, :controller

  alias Nappy.Catalog

  def new(conn, _params) do
    render(conn, "new.html", page_title: "Submit a photo")
  end

  def bulk_new(conn, _params) do
    render(conn, "bulk_new.html")
  end

  def create(conn, params) do
    tags =
      params["input-tags"]
      |> Jason.decode!()
      |> Enum.map_join(",", fn %{"value" => tag} -> tag end)

    params = %{
      category: params["photo_category"],
      file: params["photo_file"],
      tags: tags,
      title: params["photo_title"],
      user_id: conn.assigns.current_user.id
    }

    Catalog.single_upload(Nappy.bucket_name(), params)

    conn
    |> put_flash(:info, "Photo currently in pending, we'll notify you once approved.")
    |> redirect(to: "/upload")
  end

  def bulk_create(conn, params) do
    params = %{
      category: params["photo_category"],
      file: params["photo_file"],
      tags: params["photo_tags"],
      title: params["photo_title"],
      user_id: conn.assigns.current_user.id
    }

    Catalog.bulk_upload(Nappy.bucket_name(), params)

    conn
    |> put_flash(:info, "Photo currently in pending, we'll notify you once approved.")
    |> redirect(to: "/bulk-upload")
  end
end
