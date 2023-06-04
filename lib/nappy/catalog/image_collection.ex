defmodule Nappy.Catalog.ImageCollection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Collection
  alias Nappy.Catalog.Image

  @moduledoc false

  @primary_key false
  schema "images_collections" do
    belongs_to :image, Image, primary_key: true
    belongs_to :collection, Collection, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [
      :image_id,
      :collection_id
    ])
    |> validate_required([
      :image_id,
      :collection_id
    ])
    |> foreign_key_constraint(:image_id)
    |> foreign_key_constraint(:collection_id)
  end
end
