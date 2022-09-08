defmodule Nappy.Repo.Migrations.CreateImageAnalytics do
  use Ecto.Migration

  def change do
    create table(:image_analytics) do
      add :image_id, references(:images, on_delete: :delete_all), null: false
      add :view_count, :bigint, default: 0, null: false
      add :download_count, :bigint, default: 0, null: false
      add :approved_date, :naive_datetime
      add :featured_date, :naive_datetime

      timestamps()
    end

    create index(:image_analytics, [:image_id])
  end
end
