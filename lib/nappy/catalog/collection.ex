defmodule Nappy.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.Image
  alias Nappy.Catalog.ImageCollection

  @moduledoc false

  schema "collections" do
    field :description, :string
    field :is_enabled, :boolean, default: false
    field :title, :string
    field :slug, :string
    field :related_tags, :string
    belongs_to :image, Image
    belongs_to :user, User

    many_to_many :images,
                 Image,
                 join_through: ImageCollection,
                 on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :is_enabled,
      :user_id,
      :related_tags,
      :image_id
    ])
    |> validate_required([
      :user_id,
      :image_id,
      :title,
      :slug,
      :is_enabled
    ])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:image_id)
    |> unique_constraint(:slug)
  end
end

defimpl SEO.OpenGraph.Build, for: Nappy.Catalog.Collection do
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Router.Helpers, as: Routes

  def build(collection, conn) do
    SEO.OpenGraph.build(
      image: image(collection, conn),
      title: collection.title,
      description: collection.title
    )
  end

  defp image(collection, _conn) do
    SEO.OpenGraph.Image.build(
      alt: collection.title,
      height: Catalog.default_imgix_height(),
      width: Catalog.default_imgix_width(),
      type: Metrics.get_image_extension(collection.image_id),
      url: Catalog.imgix_url_by_id(collection.image_id)
    )
  end
end

defimpl SEO.Site.Build, for: Nappy.Catalog.Collection do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(collection, conn) do
    SEO.Site.build(
      url: Routes.collections_show_url(conn, :show, collection.slug),
      title: collection.title,
      description: collection.description
    )
  end
end

defimpl SEO.Twitter.Build, for: Nappy.Catalog.Collection do
  def build(collection, _conn) do
    SEO.Twitter.build(description: collection.description, title: collection.title)
  end
end

defimpl SEO.Unfurl.Build, for: Nappy.Catalog.Collection do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(collection, conn) do
    SEO.Unfurl.build(
      label1: "Collection title",
      data1: collection.title,
      label2: "Url",
      data2: Routes.collections_show_url(conn, :show, collection.slug)
    )
  end
end

defimpl SEO.Breadcrumb.Build, for: Nappy.Catalog.Collection do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(collection, conn) do
    SEO.Breadcrumb.List.build([
      %{name: collection.title, item: Routes.collections_show_url(conn, :show, collection.slug)}
    ])
  end
end
