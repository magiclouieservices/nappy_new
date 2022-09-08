defmodule Nappy.Repo.Migrations.CreateLegal do
  use Ecto.Migration

  def change do
    create table(:legal) do
      add :privacy_link, :string
      add :terms_of_agreement_link, :string
    end
  end
end
