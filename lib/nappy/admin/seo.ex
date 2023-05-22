defmodule Nappy.Admin.Seo do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "seo" do
    field :default_description, :string
    field :default_collections_description, :string
    field :default_categories_description, :string
    field :global_banner_text, :string
    field :default_keywords, :string
  end

  @doc false
  def changeset(seo, attrs) do
    seo
    |> cast(attrs, [
      :default_description,
      :default_collections_description,
      :default_categories_description,
      :global_banner_text,
      :default_keywords
    ])
  end
end
