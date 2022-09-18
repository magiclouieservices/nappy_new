defmodule Nappy.Catalog.CollectionDescription do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.{Collection, Images}

  @moduledoc false

  schema "collection_description" do
    field :description, :string
    field :is_enabled, :boolean, default: false
    field :title, :string
    field :slug, :string
    field :thumbnail, :binary_id
    belongs_to :user, User
    many_to_many :image, Images, join_through: Collection, on_replace: :delete
    has_many :collections, Collection

    timestamps()
  end

  @doc false
  def changeset(collection_description, attrs) do
    collection_description
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :is_enabled,
      :user_id,
      :thumbnail
    ])
    |> validate_required([
      :title,
      :slug,
      :description,
      :is_enabled,
      :user_id,
      :thumbnail
    ])
    |> unique_constraint(:slug)
  end
end
