defmodule Nappy.Catalog.Images do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.{Category, Collection, CollectionDescription}
  alias Nappy.Metrics.{ImageAnalytics, ImageMetadata, ImageStatus}

  @moduledoc false

  schema "images" do
    field :description, :string
    field :generated_description, :string
    field :generated_tags, :string
    field :slug, :string
    field :tags, :string
    field :title, :string
    has_many :collections, Collection, foreign_key: :image_id

    many_to_many :collection_description,
                 CollectionDescription,
                 join_through: Collection,
                 on_replace: :delete,
                 join_keys: [
                   collection_description_id: :id,
                   image_id: :id
                 ]

    # has_many :collections, Collection
    belongs_to :category, Category
    belongs_to :user, User
    has_one :image_analytics, ImageAnalytics, foreign_key: :image_id
    has_one :image_metadata, ImageMetadata, foreign_key: :image_id
    belongs_to :image_status, ImageStatus

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [
      :description,
      :generated_description,
      :generated_tags,
      :image_status_id,
      :category_id,
      :slug,
      :tags,
      :title,
      :user_id
    ])
    |> validate_required([
      :image_status_id,
      :category_id,
      :slug,
      :tags,
      :title,
      :user_id
    ])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:category_id)
    |> unique_constraint(:slug)
  end
end
