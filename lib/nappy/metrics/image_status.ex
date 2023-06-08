defmodule Nappy.Metrics.ImageStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Image

  @moduledoc false

  schema "image_status" do
    field :name, Ecto.Enum, values: [:pending, :active, :denied, :featured]
    has_many :images, Image
  end

  @doc false
  def changeset(image_status, attrs) do
    image_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, [:pending, :active, :denied, :featured])
  end
end
