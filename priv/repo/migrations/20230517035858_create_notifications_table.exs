defmodule Nappy.Repo.Migrations.CreateNotificationsTable do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :description, :text, null: false
      add :slug, :string, null: false
      add :additional_foreign_key, :binary_id, comment: "Extra details in a form of foreign key"
      timestamps()
    end
  end
end
