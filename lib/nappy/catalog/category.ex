defmodule Nappy.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Images

  @moduledoc false

  schema "categories" do
    field :is_enabled, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :related_tags, :string
    field :thumbnail, :integer
    has_many :images, Images
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [
      :name,
      :slug,
      :related_tags,
      :thumbnail,
      :is_enabled
    ])
    |> validate_required([
      :name,
      :slug,
      :thumbnail,
      :is_enabled
    ])
    |> unique_constraint(:slug)
  end
end
