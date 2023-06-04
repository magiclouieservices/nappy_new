defmodule Nappy.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :is_enabled, :boolean, default: false, null: false

      add :image_id, references(:images, on_delete: :delete_all),
        null: false,
        comment:
          "Image displayed in a specific collection page. Can choose only from available approved images."

      timestamps()
    end

    create index(:collections, [:user_id])
    create index(:collections, [:image_id])
    create unique_index(:collections, [:slug])
  end
end
