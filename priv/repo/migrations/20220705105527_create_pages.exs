defmodule Nappy.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :slug, :string, null: false, comment: "URL path name for a specific page"

      add :thumbnail, references(:images, on_delete: :delete_all),
        comment: "Image for SEO purposes. If empty or incorrect, returns the default image."

      add :is_enabled, :boolean, null: false, comment: "Is the image displayed publicly?"

      timestamps()
    end

    create unique_index(:pages, [:slug])
  end
end
