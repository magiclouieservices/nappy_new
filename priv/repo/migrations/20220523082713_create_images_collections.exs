defmodule Nappy.Repo.Migrations.CreateImagesCollections do
  use Ecto.Migration

  def change do
    create table(:images_collections, primary_key: false) do
      add :image_id, references(:images, on_delete: :delete_all), primary_key: true, null: false

      add :collection_id, references(:collections, on_delete: :delete_all),
        primary_key: true,
        null: false

      timestamps()
    end

    create index(:images_collections, [:image_id])
    create index(:images_collections, [:collection_id])
  end
end
