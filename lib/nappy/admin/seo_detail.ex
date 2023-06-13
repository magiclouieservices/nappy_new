defmodule Nappy.Admin.SeoDetail do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "seo_details" do
    field :title, :string
    field :description, :string
    field :keywords, :string
    field :url, :string
    field :type, :string
    field :extra_details, :string
  end

  @doc false
  def changeset(seo, attrs) do
    seo
    |> cast(attrs, [
      :title,
      :description,
      :keywords,
      :url,
      :type,
      :extra_details
    ])
    |> validate_required([
      :title
    ])
  end
end
