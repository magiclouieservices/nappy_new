defmodule Nappy.Accounts.SocialMedia do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User

  @moduledoc false

  schema "social_media" do
    belongs_to :user, User
    field :instagram_link, :string
    field :facebook_link, :string
    field :twitter_link, :string
    field :website_link, :string
    field :contact_email, :string
    field :bio, :string
  end

  @doc false
  def changeset(social_media, attrs) do
    social_media
    |> cast(attrs, [
      :user_id,
      :instagram_link,
      :facebook_link,
      :twitter_link,
      :website_link,
      :contact_email,
      :bio
    ])
    |> validate_required([:user_id])
  end
end
