defmodule Nappy.Catalog.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.Category
  alias Nappy.Catalog.Collection
  alias Nappy.Catalog.ImageCollection
  alias Nappy.Metrics.ImageAnalytics
  alias Nappy.Metrics.ImageMetadata
  alias Nappy.Metrics.ImageStatus

  @moduledoc false

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      encoded_fields = [
        :title,
        :slug,
        :tags,
        :description,
        :generated_description,
        :generated_tags
      ]

      value
      |> Map.take(encoded_fields)
      |> Enum.map(fn {key, val} ->
        if is_nil(val), do: {key, ""}, else: {key, val}
      end)
      |> Enum.into(%{})
      |> Jason.Encode.map(opts)
    end
  end

  schema "images" do
    field :description, :string
    field :generated_description, :string
    field :generated_tags, :string
    field :slug, :string
    field :tags, :string
    field :title, :string

    many_to_many :collections,
                 Collection,
                 join_through: ImageCollection,
                 on_replace: :delete

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
    |> foreign_key_constraint(:image_status_id)
    |> unique_constraint(:slug)
  end
end