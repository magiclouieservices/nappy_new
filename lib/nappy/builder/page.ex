defmodule Nappy.Builder.Page do
  use Nappy.Schema
  import Ecto.Changeset

  @moduledoc false

  @derive {Phoenix.Param, key: :slug}
  schema "pages" do
    field :content, :string
    field :is_enabled, :boolean
    field :slug, :string
    field :thumbnail, :binary_id
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :content, :slug, :is_enabled])
    |> validate_required([:title, :content, :slug, :is_enabled])
    |> validate_format(:slug, ~r/^[a-zA-Z]+$/, message: "only letters with no spaces")
    |> validate_length(:slug, min: 3, max: 50)
    |> validate_length(:title, min: 3, max: 50)
    |> foreign_key_constraint(:thumbnail)
    |> unique_constraint(:slug)
  end
end
