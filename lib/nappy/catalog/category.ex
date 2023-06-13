defmodule Nappy.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Image

  @moduledoc false

  schema "categories" do
    field :is_enabled, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :related_tags, :string
    belongs_to :image, Image
    has_many :images, Image
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [
      :name,
      :slug,
      :related_tags,
      :image_id,
      :is_enabled
    ])
    |> validate_required([
      :name,
      :slug,
      :image_id,
      :is_enabled
    ])
    |> unique_constraint(:slug)
  end
end

defimpl SEO.OpenGraph.Build, for: Nappy.Catalog.Category do
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias NappyWeb.Router.Helpers, as: Routes

  def build(category, conn) do
    SEO.OpenGraph.build(
      image: image(category, conn),
      title: category.name,
      description: category.name
    )
  end

  defp image(category, _conn) do
    SEO.OpenGraph.Image.build(
      alt: category.name,
      height: Catalog.default_imgix_height(),
      width: Catalog.default_imgix_width(),
      type: Metrics.get_image_extension(category.image_id),
      url: Catalog.imgix_url_by_id(category.image_id)
    )
  end
end

defimpl SEO.Site.Build, for: Nappy.Catalog.Category do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(category, conn) do
    SEO.Site.build(
      url: Routes.category_show_url(conn, :show, category.slug),
      title: category.name,
      description: category.name
    )
  end
end

defimpl SEO.Twitter.Build, for: Nappy.Catalog.Category do
  def build(category, _conn) do
    SEO.Twitter.build(description: category.name, title: category.name)
  end
end

defimpl SEO.Unfurl.Build, for: Nappy.Catalog.Category do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(category, conn) do
    SEO.Unfurl.build(
      label1: "Category name",
      data1: category.name,
      label2: "Url",
      data2: Routes.category_show_url(conn, :show, category.slug)
    )
  end
end

defimpl SEO.Breadcrumb.Build, for: Nappy.Catalog.Category do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(category, conn) do
    SEO.Breadcrumb.List.build([
      %{name: category.name, item: Routes.category_show_url(conn, :show, category.slug)}
    ])
  end
end
