defmodule Nappy.Metrics.LikedImage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.Image

  @moduledoc false

  schema "liked_images" do
    field :is_liked, :boolean, default: false
    belongs_to :image, Image
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(liked_image, attrs) do
    liked_image
    |> cast(attrs, [
      :is_liked,
      :image_id,
      :user_id
    ])
    |> validate_required([
      :is_liked,
      :image_id,
      :user_id
    ])
    |> foreign_key_constraint(:image_id)
    |> foreign_key_constraint(:user_id)
  end
end
