defmodule Nappy.Search do
  @moduledoc """
  Search implemented using [`ex_typesense`](https://github.com/jaeyson/ex_typesense)
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Nappy.Accounts.User
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
    |> Changeset.cast(attrs, [
      :search_phrase
    ])
    |> Changeset.validate_required([:search_phrase])
    |> Changeset.update_change(:search_phrase, &String.trim/1)
    |> Changeset.validate_length(:search_phrase, min: 2)
    |> Changeset.validate_format(:search_phrase, ~r/[A-Za-z0-9\ ]/)
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

    query =
      case image_status do
        :all ->
          Image

        _ ->
          Image
          |> where(image_status_id: ^Metrics.get_image_status_id(image_status))
      end

    query
    |> join(:inner, [i], u in assoc(i, :user))
    |> join(:inner, [i, _u], im in assoc(i, :image_metadata))
    |> join(:inner, [i, _u, _im], ia in assoc(i, :image_analytics))
    |> where([_i, u, _im, _ia], ilike(u.username, ^"%#{search_string}%"))
    |> or_where([i, _u, _im, _ia], ilike(i.title, ^"%#{search_string}%"))
    |> or_where([i, _u, _im, _ia], ilike(i.tags, ^"%#{search_string}%"))
    |> or_where([i, _u, _im, _ia], ilike(i.generated_tags, ^"%#{search_string}%"))
    |> or_where([i, _u, _im, _ia], ilike(i.slug, ^"%#{search_string}%"))
    |> order_by(^order_by)
    |> select([i, u, im, ia], %Image{
      id: i.id,
      description: i.description,
      generated_description: i.generated_description,
      generated_tags: i.generated_tags,
      slug: i.slug,
      tags: i.tags,
      title: i.title,
      category_id: i.category_id,
      image_analytics: ia,
      image_metadata: im,
      image_status_id: i.image_status_id,
      user_id: u.id,
      user: u,
      inserted_at: i.inserted_at,
      updated_at: i.updated_at
    })
    |> Repo.paginate(params)
  end
end
