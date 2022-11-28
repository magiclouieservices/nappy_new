defmodule NappyWeb.ImageLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Admin.Slug
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.MoreInfoComponent
  alias NappyWeb.Components.RelatedImagesComponent
  alias NappyWeb.Components.SponsoredImagesComponent
  alias Plug.Conn.Status

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
       sponsored_images: placeholder,
       related_images: placeholder
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
        preload = [:user, :image_metadata, :image_analytics]
        image = Catalog.get_image_by_slug(slug, preload: preload, select: nil)
        ext = image.image_metadata.extension_type
        status = Metrics.get_status_name(image.image_status_id)
        tags = Catalog.image_tags_as_list(image.tags, image.generated_tags)
        sponsored_images = SponsoredImages.get_images(image.slug, image.tags)
        related_images = GalleryComponent.related_images(image.slug)

        socket =
          socket
          |> assign(image: image)
          |> assign(status: status)
          |> assign(ext: ext)
          |> assign(tags: tags)
          |> assign(sponsored_images: sponsored_images)
          |> assign(related_images: related_images)
          |> assign(page_title: image.title)

        {:noreply, socket}
      end
    else
      raise NappyWeb.FallbackController, Status.code(:not_found)
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
end
