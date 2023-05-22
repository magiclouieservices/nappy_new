defmodule Nappy.Accounts.AccountStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts.User

  @moduledoc false

  schema "account_status" do
    field :name, Ecto.Enum, values: [:pending, :active, :banned]
    has_many :users, User
  end

  @doc false
  def changeset(account_status, attrs) do
    account_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, [:pending, :active, :banned])
    |> unique_constraint(:name)
  end
end
