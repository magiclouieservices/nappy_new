defmodule Nappy.Repo.Migrations.CreateReferrers do
  use Ecto.Migration

  def change do
    create table(:referrers) do
      add :name, :string
    end

    create unique_index(:referrers, [:name])

    alter table(:subscribers) do
      add :referrer_id, references(:referrers, on_delete: :delete_all, on_update: :update_all),
        null: false
    end

    create index(:subscribers, [:referrer_id])
  end
end
