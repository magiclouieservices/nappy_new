defmodule Nappy.Catalog.Collection do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.{CollectionDescription, Images}

  @moduledoc false

  schema "collections" do
    belongs_to :image, Images, primary_key: true
    belongs_to :collection_description, CollectionDescription, primary_key: true

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
  end
end
