defmodule Nappy.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, comment: "Table for user accounts") do
      add :email, :citext, null: false
      add :username, :string, size: 30, null: false
      add :slug, :string, null: false
      add :name, :string, size: 50
      add :avatar_link, :string, comment: "user's profile image"
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
    create unique_index(:users, [:slug])
    create unique_index(:users_tokens, [:context, :token])
  end
end
