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

  @types %{search_phrase: :string}

  def changeset(search_keyword) do
    attrs = %{search_phrase: search_keyword}

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

    Images
    |> where([i], i.image_status_id in ^[active, featured])
    |> _query(normalize(search_string))
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
        ORDER BY RANDOM()
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^"%#{unquote(search_string)}%",
        ^"%#{unquote(search_string)}%",
        ^"%#{unquote(search_string)}%"
      )
    end
  end

  defp _query(query, ""), do: query

  defp _query(query, search_string) do
    from image in query,
      join: id_and_rank in matching_search_ids_and_ranks(search_string),
      on: id_and_rank.id == image.id,
      # order_by: [desc: id_and_rank.rank]
      order_by: fragment("RANDOM()")
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

  defp prefix_search(term) do
    String.replace(term, ~r/\W/u, "") <> ":*"
  end
end
