defmodule Nappy.Repo.Migrations.CreateAccountStatus do
  use Ecto.Migration

  def change do
    create table(:account_status) do
      add :name, :string, null: false
    end

    create unique_index(:account_status, [:name])

    alter table(:users) do
      add :account_status_id,
          references(:account_status, on_delete: :delete_all, on_update: :update_all),
          null: false
    end

    create index(:users, [:account_status_id])
  end
end
