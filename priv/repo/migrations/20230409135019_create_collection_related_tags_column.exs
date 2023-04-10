defmodule Nappy.Repo.Migrations.CreateCollectionRelatedTagsColumn do
  use Ecto.Migration

  def change do
    alter table(:collection_description) do
      add :related_tags, :string
    end
  end
end
