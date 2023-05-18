defmodule Nappy.Metrics.LikedImage do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Catalog.Images

  @moduledoc false

  schema "liked_images" do
    field :is_liked, :boolean, default: false
    belongs_to :image, Images
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
    |> foreign_key_constraint(:image_id)
    |> foreign_key_constraint(:user_id)
    |> validate_required([
      :is_liked
    ])
  end
end
