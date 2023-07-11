defmodule Nappy.Search do
  @moduledoc """
  Search implemented using [`ex_typesense`](https://github.com/jaeyson/ex_typesense)
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Nappy.Catalog.Image
  alias Nappy.Metrics
  alias Nappy.Repo

  @image_status_names Ecto.Enum.values(Metrics.ImageStatus, :name)
  # @full_list_status_names [:all, :popular | @image_status_names]
  @types %{search_phrase: :string}
  @query_by "title,tags,generated_tags"
  @default_page_size 12

  def changeset(search_phrase) do
    attrs = %{search_phrase: search_phrase}

    {%{}, @types}
    |> cast(attrs, [
      :search_phrase
    ])
    |> validate_required([:search_phrase])
    |> update_change(:search_phrase, &String.trim/1)
    |> validate_length(:search_phrase, min: 2)
    |> validate_format(:search_phrase, ~r/[A-Za-z0-9\ ]/)
  end

  def paginate_search(search_string, params) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    search_params = %{
      q: search_string,
      query_by: @query_by,
      page: params[:page],
      per_page: params[:page_size]
    }

    Image
    |> ExTypesense.search(search_params)
    |> where([i], i.image_status_id in ^[active, featured])
    |> order_by(fragment("RANDOM()"))
    |> preload([:user, :image_metadata, :image_analytics])
    |> Repo.paginate(params)
  end

  def paginate_admin_search(search_string, params) do
    sort_order = if params[:sort_order] === :asc, do: :desc, else: :asc
    order_by = {sort_order, :title}
    image_status = params[:image_status]

    case image_status do
      :all ->
        params = %{q: search_string, query_by: @query_by}
        ExTypesense.search(Image, params)

      _ ->
        params = %{q: "", query_by: @query_by}

        Image
        |> ExTypesense.search(params)
        |> where(image_status_id: ^Metrics.get_image_status_id(image_status))
    end
    |> preload([:user, :image_metadata, :image_analytics])
    |> order_by(^order_by)
    |> Repo.paginate(params)
  end
end
