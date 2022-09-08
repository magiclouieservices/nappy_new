defmodule Nappy.Repo.Migrations.CreateImageMetadata do
  use Ecto.Migration

  def change do
    create table(:image_metadata) do
      add :image_id, references(:images, on_delete: :delete_all), null: false
      add :extension_type, :string, null: false
      add :height, :integer, null: false
      add :width, :integer, null: false
      add :file_size, :float, null: false, comment: "measured by Bytes"
      add :focal, :float, comment: "measured by mm"
      add :iso, :integer
      add :shutter_speed, :float
      add :aperture, :float
      add :aspect_ratio, :float
      add :device_model, :string
      add :camera_software, :string
      add :color_palette, :string

      timestamps()
    end

    create index(:image_metadata, [:image_id])
  end
end
