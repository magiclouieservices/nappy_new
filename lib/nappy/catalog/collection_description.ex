defmodule Nappy.Catalog.CollectionDescription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.{Collection, Images}

  @moduledoc false

  schema "collection_description" do
    field :description, :string
    field :is_enabled, :boolean, default: false
    field :title, :string
    field :slug, :string
    field :related_tags, :string
    field :thumbnail, :integer
    belongs_to :user, User

    many_to_many :images,
                 Images,
                 join_through: Collection,
                 on_replace: :delete,
                 join_keys: [
                   collection_description_id: :id,
                   image_id: :id
                 ]

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
      :related_tags,
      :thumbnail
    ])
    |> validate_required([
      :user_id,
      :thumbnail,
      :title,
      :slug,
      :description,
      :is_enabled
    ])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:thumbnail)
    |> unique_constraint(:slug)
  end
end
