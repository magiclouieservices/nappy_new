defmodule Nappy.Builder do
  @moduledoc """
  The Builder context.
  """

  import Ecto.Query, warn: false
  alias Nappy.Repo

  alias Nappy.Builder.Page

  # @slug_path "priv/repo/slug_paths.txt"

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages do
    Repo.all(Page)
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id), do: Repo.get!(Page, id)

  def get_page_by_slug_name(slug_name) do
    query = from p in Page, where: p.slug == ^slug_name
    Repo.one(query)
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(attrs \\ %{}) do
    page =
      %Page{}
      |> Page.changeset(attrs)
      |> Repo.insert()

    case page do
      {:ok, page} ->
        write_slug_paths_to_file()
        {:ok, page}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp write_slug_paths_to_file do
    slug_paths =
      from(p in Page, select: p.slug)
      |> Repo.all()
      |> Enum.map(&(&1 <> "\n"))

    Nappy.slug_paths_filename()
    # @slug_path
    |> File.write(slug_paths)

    Code.compile_file("lib/nappy_web/router.ex")
  end

  def get_slug_routes do
    Nappy.slug_paths_filename()
    # @slug_path
    |> File.read()
    |> case do
      {:ok, contents} ->
        String.split(contents, "\n", trim: true)

      {:error, _reason} ->
        # :file.format_error(reason)
        write_slug_paths_to_file()

        Nappy.slug_paths_filename()
        # @slug_path
        |> File.read!()
        |> String.split("\n", trim: true)
    end
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
    write_slug_paths_to_file()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{data: %Page{}}

  """
  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
    write_slug_paths_to_file()
  end
end
