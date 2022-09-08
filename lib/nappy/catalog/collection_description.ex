defmodule Nappy.Catalog.CollectionDescription do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.Collection

  @moduledoc false

  schema "collection_description" do
    field :description, :string
    field :is_enabled, :boolean, default: false
    field :title, :string
    field :thumbnail, :binary_id
    belongs_to :user, User
    has_many :collections, Collection

    timestamps()
  end

  @doc false
  def changeset(collection_description, attrs) do
    collection_description
    |> cast(attrs, [
      :title,
      :description,
      :is_enabled,
      :user_id,
      :thumbnail
    ])
    |> validate_required([
      :title,
      :description,
      :is_enabled,
      :user_id,
      :thumbnail
    ])
  end
end
