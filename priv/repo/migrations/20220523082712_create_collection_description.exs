defmodule Nappy.Repo.Migrations.CreateCollectionDescription do
  use Ecto.Migration

  def change do
    create table(:collection_description) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :description, :text
      add :is_enabled, :boolean, default: false, null: false

      # add :thumbnail, :binary_id,
      #   comment:
      #     "Image displayed in a specific collection page. Can choose only from available approved images."
      add :thumbnail, references(:images, on_delete: :delete_all),
        null: false,
        comment:
          "Image displayed in a specific collection page. Can choose only from available approved images."

      timestamps()
    end

    create index(:collection_description, [:user_id])
    create index(:collection_description, [:thumbnail])

    alter table(:collections) do
      add :collection_description_id, references(:collection_description, on_delete: :delete_all),
        null: false
    end

    create index(:collections, [:collection_description_id])
  end
end
