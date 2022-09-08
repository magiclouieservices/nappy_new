defmodule Nappy.Repo.Migrations.CreateAccountRole do
  use Ecto.Migration

  def change do
    create table(:account_role) do
      add :name, :string, null: false
    end

    alter table(:users) do
      add :account_role_id,
          references(:account_role, on_delete: :delete_all, on_update: :update_all),
          null: false
    end

    create index(:users, [:account_role_id])
    create unique_index(:account_role, [:name])
  end
end
