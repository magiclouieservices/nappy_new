defmodule Nappy.Admin.Legal do
  use Nappy.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "legal" do
    field :privacy_link, :string
    field :terms_of_agreement_link, :string
  end

  @doc false
  def changeset(legal, attrs) do
    legal
    |> cast(attrs, [:privacy_link, :terms_of_agreement_link])
  end
end
