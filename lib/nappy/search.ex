defmodule Nappy.Search do
  @moduledoc """
  Search implemented using FTS, materialized
  views, though not a full alternative to
  Typesense.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Nappy.Catalog.Images
  alias Nappy.Metrics
  alias Nappy.Repo

  @image_status_names Ecto.Enum.values(Metrics.ImageStatus, :name)
  @full_list_status_names [:all, :popular | @image_status_names]
  @types %{search_phrase: :string}

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
    order_by = :random

    Images
    |> where([i], i.image_status_id in ^[active, featured])
    |> prepare_paginated_query(search_string, params, order_by)
  end

  def paginate_admin_search(search_string, params) do
    sort_order = if params[:sort_order] === :asc, do: :desc, else: :asc
    order_by = {sort_order, :title}
    image_status = params[:image_status]

    case image_status do
      :all ->
        Images

      _ ->
        Images
        |> where(image_status_id: ^Metrics.get_image_status_id(image_status))
    end
    |> prepare_paginated_query(search_string, params, order_by)
  end

  defp prepare_paginated_query(query, search_string, params, order_by) do
    query
    |> _query(normalize(search_string), order_by)
    |> preload([:user, :image_metadata, :image_analytics])
    |> Repo.paginate(params)
  end

  defmacro matching_search_ids_and_ranks(search_string) do
    quote do
      fragment(
        """
        SELECT image_search.id AS id,
        ts_rank(
          search_document, plainto_tsquery(unaccent(?))
        ) AS rank
        FROM image_search
        WHERE search_document @@ plainto_tsquery(unaccent(?))
        OR image_search.title ILIKE ?
        OR image_search.tags ILIKE ?
        OR image_search.generated_tags ILIKE ?
        OR image_search.username ILIKE ?
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^"%#{unquote(search_string)}%",
        ^"%#{unquote(search_string)}%",
        ^"%#{unquote(search_string)}%",
        ^"%#{unquote(search_string)}%"
      )
    end
  end

  defp _query(query, "", _order_by), do: query

  defp _query(query, search_string, order_by) do
    query =
      query
      |> join(:inner, [image], rank in matching_search_ids_and_ranks(search_string),
        on: rank.id == image.id
      )

    case order_by do
      :random ->
        query
        |> order_by(fragment("RANDOM()"))

      {sort_order, sort_by} ->
        query
        |> order_by({^sort_order, ^sort_by})
    end

    # from image in query,
    #   join: id_and_rank in matching_search_ids_and_ranks(search_string),
    #   on: id_and_rank.id == image.id,
    #   order_by: fragment("RANDOM()")
    #   # order_by: [desc: id_and_rank.id]
  end

  defp normalize(search_string) do
    search_string
    |> String.downcase()
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim()
  end

  @doc """
  Search without substring matches. This is
  limited because you can only search at the
  beginning of the word. Like "umbrell%" where
  it should always start with "umbrell".

  Returns a list of Images struct(s).

  ## Examples

    iex> Search.search_image("umbrella")
    [%Images{...}, ...]

  """
  def search_image(search_term) do
    Images
    |> where(
      fragment(
        "to_tsvector('english', title || ' ' || tags || ' ' || coalesce(title, ' ')) @@ to_tsquery(?)",
        ^prefix_search(search_term)
      )
    )
    |> order_by(fragment("RANDOM()"))
    |> Repo.paginate()
  end

  @doc """
  Fuzzy image search used for admin page.
  The results are somewhat limited compared
  to the search bar at homepage and navbar.

  Returns paginated results.

  ## Examples

    iex> Search.paginate_admin_fuzzy_search("umbrella", page: 1, page_size: 12)
    %Scrivener.Page{
      page_number: 1,
      page_size: 12,
      total_entries: 1,
      total_pages: 1,
      entries: [
        %Nappy.Catalog.Images{...}
      ]
    }

  """
  def paginate_admin_fuzzy_search(search_term, params) do
    first_letter = String.slice(search_term, 0..3)

    Images
    |> where([i], fragment("SIMILARITY(?, ?) > 0 ", i.title, ^search_term))
    |> where([i], ilike(i.title, ^"%#{first_letter}%"))
    |> or_where([i], ilike(i.tags, ^"%#{first_letter}%"))
    |> order_by([i], fragment("LEVENSHTEIN(?, ?)", i.title, ^search_term))
    |> preload([:user, :image_metadata, :image_analytics])
    |> Repo.paginate(params)
  end

  def admin_changeset(attrs \\ %{}) do
    types = %{search_phrase: :string}

    {%{}, types}
    |> cast(attrs, [:search_phrase])
    |> validate_required([:search_phrase])
    |> update_change(:search_phrase, &String.trim/1)
    |> validate_length(:search_phrase, min: 2)
    |> validate_format(:search_phrase, ~r/[A-Za-z0-9\ ]/)
  end

  defp prefix_search(term) do
    String.replace(term, ~r/\W/u, "") <> ":*"
  end
end
