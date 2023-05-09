defmodule Nappy.Newsletter.Subscriber do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User
  alias Nappy.Newsletter.Referrer

  @moduledoc false

  schema "subscribers" do
    belongs_to :user, User
    belongs_to :referrer, Referrer
    field :is_photographer, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [
      :is_photographer,
      :referrer_id,
      :user_id
    ])
    |> validate_required([
      :referrer_id,
      :user_id
    ])
  end
end
