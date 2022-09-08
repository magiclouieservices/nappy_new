defmodule Nappy.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :slug, :string, null: false, comment: "URL path name per image"
      add :description, :text
      add :generated_description, :text
      add :tags, :text, null: false
      add :generated_tags, :text

      timestamps()
    end

    create index(:images, [:user_id])
    create unique_index(:images, [:slug])
  end
end
