defmodule Nappy.Repo.Migrations.CreateSocialMedia do
  use Ecto.Migration

  def change do
    create table(:social_media) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :instagram_link, :string
      add :facebook_link, :string
      add :twitter_link, :string
      add :website_link, :string
      add :contact_email, :string
      add :bio, :string, comment: "user's profile description"
    end

    create index(:social_media, [:user_id])
  end
end
