defmodule Nappy.Repo.Migrations.CreateRelatedTagsColumn do
  use Ecto.Migration

  def change do
    alter table(:collections) do
      add :related_tags, :text
    end

    alter table(:categories) do
      add :related_tags, :text
    end
  end
end
