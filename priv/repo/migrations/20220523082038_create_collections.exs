defmodule Nappy.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :image_id, references(:images, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:collections, [:image_id])
  end
end
