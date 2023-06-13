defmodule Nappy.Repo.Migrations.CreateHomepageSeoDetails do
  use Ecto.Migration

  def change do
    create table(:homepage_seo_details) do
      add :filter, :string, null: false, comment: "mode of images in homepage"
      add :title, :string, null: false
      add :description, :string, null: false
      timestamps()
    end

    create unique_index(:homepage_seo_details, [:filter])
  end
end
