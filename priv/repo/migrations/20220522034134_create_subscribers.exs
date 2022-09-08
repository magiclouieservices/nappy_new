defmodule Nappy.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :is_photographer, :boolean, default: false, null: false

      timestamps()
    end

    create index(:subscribers, [:user_id])
  end
end
