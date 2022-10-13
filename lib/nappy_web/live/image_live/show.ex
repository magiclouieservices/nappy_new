defmodule NappyWeb.ImageLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Admin.Slug
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.RelatedImagesComponent
  alias NappyWeb.Components.SponsoredImagesComponent

  @moduledoc false

  @impl true
  def mount(_params, _session, socket) do
    placeholder = Enum.map(1..5, fn _ -> "#" end)

    {:ok,
     socket
     |> assign(status: nil)
     |> assign(ext: nil)
     |> assign(tags: []),
     temporary_assigns: [
       image: [],
       sponsored_images: [placeholder]
     ]}
  end

  @impl true
  def handle_params(%{"slug" => slug_path}, _uri, socket) do
    list = String.split(slug_path, "-", trim: true)
    slug = List.last(list)
    title = Enum.filter(list, &(&1 !== slug)) |> Enum.join(" ")
    image = Catalog.get_image_by_slug(slug)

    if image do
      path = Slug.slugify(image.title)

      if title === "" do
        image_show_path = Routes.image_show_path(socket, :show, "#{path}-#{slug}")
        {:noreply, push_redirect(socket, to: image_show_path)}
      else
        preload = [:user, :image_metadata, collections: :collection_description]
        image = Catalog.get_image_by_slug(slug, preload: preload, select: nil)
        ext = image.image_metadata.extension_type
        status = Metrics.get_status_name(image.image_status_id)
        tags = Catalog.image_tags_as_list(image.tags, image.generated_tags)
        sponsored_images = sponsored_images(image.slug, image.tags)

        socket =
          socket
          |> assign(image: image)
          |> assign(status: status)
          |> assign(ext: ext)
          |> assign(tags: tags)
          |> assign(sponsored_images: sponsored_images)

        {:noreply, socket}
      end
    else
      # socket
      # |> put_status(403)
      # |> put_view(NappyWeb.ErrorView)
      # |> render(:"403")

      raise NappyWeb.NotFoundError
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign(status: nil)
     |> assign(ext: nil)
     |> assign(tags: [])}
  end

  defp sponsored_images(slug, tags) do
    tag =
      tags
      |> String.split(",", trim: true)
      |> hd()

    SponsoredImages.get_images(slug, tag)
  end
end
