defmodule Nappy.Metrics.Notifications do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User

  @moduledoc false

  schema "notifications" do
    belongs_to :user, User
    field :description, :string
    field :additional_foreign_key, :binary_id

    timestamps()
  end

  @doc false
  def changeset(notifications, attrs) do
    notifications
    |> cast(attrs, [
      :user_id,
      :description,
      :additional_foreign_key
    ])
    |> foreign_key_constraint(:user_id)
    |> validate_required([
      :description
    ])
  end
end
