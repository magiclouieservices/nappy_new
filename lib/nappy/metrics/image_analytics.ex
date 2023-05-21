defmodule Nappy.Metrics.ImageAnalytics do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Images

  @moduledoc false

  schema "image_analytics" do
    belongs_to :image, Images
    field :approved_date, :naive_datetime
    field :download_count, :integer
    field :featured_date, :naive_datetime
    field :view_count, :integer

    timestamps()
  end

  @doc false
  def changeset(image_analytics, attrs) do
    image_analytics
    |> cast(attrs, [
      :image_id,
      :view_count,
      :download_count,
      :approved_date,
      :featured_date
    ])
    |> validate_required([
      :image_id
    ])
    |> foreign_key_constraint(:image_id)
  end
end
