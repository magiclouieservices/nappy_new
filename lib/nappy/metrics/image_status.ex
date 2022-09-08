defmodule Nappy.Metrics.ImageStatus do
  use Nappy.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Images

  @moduledoc false

  schema "image_status" do
    field :name, Ecto.Enum, values: [:pending, :active, :denied, :featured]
    has_many :images, Images
  end

  @doc false
  def changeset(image_status, attrs) do
    image_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, [:pending, :active, :denied, :featured])
  end
end
