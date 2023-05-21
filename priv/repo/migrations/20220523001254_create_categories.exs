defmodule Nappy.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false, comment: "URL path name for a specific category"

      add :thumbnail, :integer, comment: "Can choose only from available approved images."

      add :is_enabled, :boolean,
        default: false,
        null: false,
        comment: "Category will be shown publicly if set to true"
    end

    create unique_index(:categories, [:slug])
    create index(:categories, [:thumbnail])

    alter table(:images) do
      add :category_id,
          references(:categories, on_delete: :delete_all, on_update: :update_all),
          null: false
    end

    create index(:images, [:category_id])
  end
end
