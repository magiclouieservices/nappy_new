defmodule NappyWeb.ImageLive.Show do
  use NappyWeb, :live_view

  alias Nappy.Accounts
  alias Nappy.Admin.Slug
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.SponsoredImages
  alias NappyWeb.Components.DownloadComponent
  alias NappyWeb.Components.GalleryComponent
  alias NappyWeb.Components.MoreInfoComponent
  alias NappyWeb.Components.RelatedImagesComponent
  alias NappyWeb.Components.SaveToCollectionComponent
  alias NappyWeb.Components.ShareLinkComponent
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
  def handle_params(%{"slug" => slug_path}, uri, socket) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)
    list = String.split(slug_path, "+", trim: true)
    slug = List.last(list)
    title = Enum.filter(list, &(&1 !== slug)) |> Enum.join(" ")
    image = Catalog.get_image_by_slug(slug)

    if image do
      current_user = socket.assigns[:current_user]
      admin = Nappy.Accounts.is_admin_or_contributor(current_user, [:admin])
      is_owner_or_admin = current_user === image.user_id || admin
      approved_image = image.image_status_id in [active, featured] || is_owner_or_admin
      path = Slug.slugify(image.title)

      if connected?(socket) do
        slug
        |> Nappy.Metrics.get_image_analytics_by_slug()
        |> Nappy.Metrics.increment_view_count()
      end

      if title === "" && approved_image do
        image_show_path = Routes.image_show_path(socket, :show, "#{path}+#{slug}")
        {:noreply, push_redirect(socket, to: image_show_path)}
      else
        preload = [:user, :image_metadata, :image_analytics]
        image = Catalog.get_image_by_slug(slug, preload: preload, select: nil)
        ext = image.image_metadata.extension_type
        status = Metrics.get_status_name(image.image_status_id)
        tags = Catalog.image_tags_as_list(image.tags, image.generated_tags)
        sponsored_images = SponsoredImages.get_images(image.slug, image.tags)
        related_images = GalleryComponent.related_images(image.slug)
        redirect_path = Path.join(["/", "photo", image.slug])

        socket =
          socket
          |> assign(image: image)
          |> assign(status: status)
          |> assign(ext: ext)
          |> assign(tags: tags)
          |> assign(redirect_path: redirect_path)
          |> assign(sponsored_images: sponsored_images)
          |> assign(related_images: related_images)
          |> assign(page_title: image.title)
          |> assign(current_url: uri)

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

  @impl true
  def handle_event("increment_view_count", %{"slug" => slug}, socket) do
    slug
    |> Metrics.get_image_analytics_by_slug()
    |> Metrics.increment_view_count()

    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_info, socket) do
    {:noreply, clear_flash(socket, :info)}
  end
end
