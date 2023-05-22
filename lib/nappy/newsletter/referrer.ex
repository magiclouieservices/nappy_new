defmodule Nappy.Newsletter.Referrer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Newsletter.Subscriber

  @moduledoc false

  schema "referrers" do
    field :name, :string
    has_many :subscribers, Subscriber
  end

  @doc false
  def changeset(referrer, attrs) do
    referrer
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
