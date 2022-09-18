defmodule Nappy.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :image_id, references(:images, on_delete: :delete_all), null: false, primary_key: true

      add :collection_description_id, references(:collection_description, on_delete: :delete_all),
        null: false,
        primary_key: true

      timestamps()
    end

    create index(:collections, [:image_id])
    create index(:collections, [:collection_description_id])

    create unique_index(:collections, [:image_id, :collection_description_id],
             name: :collections_unique_index
           )
  end
end
