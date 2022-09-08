defmodule NappyWeb.ImageController do
  use NappyWeb, :controller

  alias Nappy.Admin.Slug
  alias Nappy.{Catalog, Metrics}

  def show(conn, %{"slug" => slug_path} = _params) do
    list = String.split(slug_path, "-", trim: true)
    slug = List.last(list)
    title = Enum.filter(list, &(&1 !== slug)) |> Enum.join(" ")
    image = Catalog.get_image_by_slug(slug, preload: [], select: [:title])

    if is_nil(image) do
      conn
      |> put_status(:not_found)
      |> put_view(NappyWeb.ErrorView)
      |> render("404.html")
    else
      path = Slug.slugify(image.title)

      if title === "" do
        redirect(conn, to: "/photo/#{path}-#{slug}")
      end

      if title === image.title do
        image =
          Catalog.get_image_by_slug(slug,
            preload: [:user, :image_metadata, collections: :collection_description],
            select: nil
          )

        ext = image.image_metadata.extension_type

        status = Metrics.get_status_name(image.image_status_id)

        tags = Catalog.image_tags_as_list(image.tags, image.generated_tags)

        render(conn, "show.html", image: image, status: status, ext: ext, tags: tags)
      end
    end
  end
end
