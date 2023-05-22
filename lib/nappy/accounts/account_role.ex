defmodule Nappy.Accounts.AccountRole do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User

  @moduledoc false

  schema "account_role" do
    field :name, Ecto.Enum, values: [:normal, :admin, :contributor]
    has_many :users, User
  end

  @doc false
  def changeset(account_role, attrs) do
    account_role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, [:normal, :admin, :contributor])
    |> unique_constraint(:name)
  end
end
