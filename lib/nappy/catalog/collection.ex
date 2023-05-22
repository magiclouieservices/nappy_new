defmodule Nappy.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.{CollectionDescription, Images}

  @moduledoc false

  schema "collections" do
    belongs_to :image, Images, foreign_key: :image_id
    belongs_to :collection_description, CollectionDescription

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [
      :image_id,
      :collection_description_id
    ])
    |> validate_required([
      :image_id,
      :collection_description_id
    ])
    |> foreign_key_constraint(:image_id)
    |> foreign_key_constraint(:collection_description_id)
  end
end
