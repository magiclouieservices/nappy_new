defmodule Nappy.Repo.Migrations.CreateSeoDetails do
  use Ecto.Migration

  def change do
    create table(:seo_details) do
      add :title, :string, null: false
      add :description, :string, null: true
      add :keywords, :string, null: true, comment: "seo keywords, delimited by comma"
      add :url, :string, null: true
      add :type, :string, null: true
      add :extra_details, :string, null: true
    end
  end
end
