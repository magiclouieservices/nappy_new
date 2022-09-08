defmodule Nappy.Repo.Migrations.CreateLikedImages do
  use Ecto.Migration

  def change do
    create table(:liked_images) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :image_id, references(:images, on_delete: :delete_all), null: false
      add :is_liked, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:liked_images, [:user_id, :image_id])
  end
end
