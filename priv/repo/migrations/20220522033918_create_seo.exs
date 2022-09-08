defmodule Nappy.Repo.Migrations.CreateSeo do
  use Ecto.Migration

  def change do
    create table(:seo) do
      add :default_description, :string
      add :default_collections_description, :string
      add :default_categories_description, :string
      add :global_banner_text, :string
      add :default_keywords, :string
    end
  end
end
