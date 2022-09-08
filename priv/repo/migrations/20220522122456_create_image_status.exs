defmodule Nappy.Repo.Migrations.CreateImageStatus do
  use Ecto.Migration

  def change do
    create table(:image_status) do
      add :name, :string, null: false
    end

    create unique_index(:image_status, [:name])

    alter table(:images) do
      add :image_status_id,
          references(:image_status, on_delete: :delete_all, on_update: :update_all),
          null: false
    end

    create index(:images, [:image_status_id])
  end
end
