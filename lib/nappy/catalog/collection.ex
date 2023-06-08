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
