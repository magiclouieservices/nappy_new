defmodule Nappy.Metrics.ImageMetadata do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Catalog.Image

  @moduledoc false

  schema "image_metadata" do
    belongs_to :image, Image
    field :aperture, :float
    field :aspect_ratio, :float
    field :camera_software, :string
    field :device_model, :string
    field :extension_type, :string
    field :file_size, :float
    field :focal, :float
    field :height, :integer
    field :iso, :integer
    field :shutter_speed, :float
    field :width, :integer
    field :color_palette, :string

    timestamps()
  end

  @doc false
  def changeset(image_metadata, attrs) do
    image_metadata
    |> cast(attrs, [
      :image_id,
      :extension_type,
      :height,
      :width,
      :file_size,
      :focal,
      :iso,
      :shutter_speed,
      :aperture,
      :aspect_ratio,
      :device_model,
      :camera_software,
      :color_palette
    ])
    |> validate_required([
      :image_id,
      :extension_type,
      :height,
      :width,
      :file_size
      # :focal,
      # :iso,
      # :shutter_speed,
      # :aperture,
      # :aspect_ratio,
      # :device_model,
      # :camera_software
    ])
    |> foreign_key_constraint(:image_id)
  end
end
