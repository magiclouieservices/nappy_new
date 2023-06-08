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
