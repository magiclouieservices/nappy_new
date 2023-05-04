defmodule Nappy.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nappy.Admin.AdminSettings
  alias Nappy.Admin.Legal
  alias Nappy.Admin.Seo
  alias Nappy.Catalog
  alias Nappy.Catalog.Images
  alias Nappy.Repo

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Settings{}, ...]

  """
  def list_settings do
    Repo.all(AdminSettings)
  end

  def max_tag_count, do: hd(list_settings()).max_tag_count

  @doc """
  Gets a single settings.

  Raises `Ecto.NoResultsError` if the Settings does not exist.

  ## Examples

      iex> get_settings!(123)
      %Settings{}

      iex> get_settings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_settings!(id), do: Repo.get!(AdminSettings, id)

  @doc """
  Creates a settings.

  ## Examples

      iex> create_settings(%{field: value})
      {:ok, %Settings{}}

      iex> create_settings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_settings(attrs \\ %{}) do
    %AdminSettings{}
    |> AdminSettings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a settings.

  ## Examples

      iex> update_settings(settings, %{field: new_value})
      {:ok, %Settings{}}

      iex> update_settings(settings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_settings(%AdminSettings{} = settings, attrs) do
    settings
    |> AdminSettings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a settings.

  ## Examples

      iex> delete_settings(settings)
      {:ok, %Settings{}}

      iex> delete_settings(settings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_settings(%AdminSettings{} = settings) do
    Repo.delete(settings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking settings changes.

  ## Examples

      iex> change_settings(settings)
      %Ecto.Changeset{data: %Settings{}}

  """
  def change_settings(%AdminSettings{} = settings, attrs \\ %{}) do
    AdminSettings.changeset(settings, attrs)
  end

  @doc """
  Returns the list of legal.

  ## Examples

      iex> list_legal()
      [%Legal{}, ...]

  """
  def list_legal do
    Repo.all(Legal)
  end

  @doc """
  Gets a single legal.

  Raises `Ecto.NoResultsError` if the Legal does not exist.

  ## Examples

      iex> get_legal!(123)
      %Legal{}

      iex> get_legal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_legal!(id), do: Repo.get!(Legal, id)

  @doc """
  Creates a legal.

  ## Examples

      iex> create_legal(%{field: value})
      {:ok, %Legal{}}

      iex> create_legal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_legal(attrs \\ %{}) do
    %Legal{}
    |> Legal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a legal.

  ## Examples

      iex> update_legal(legal, %{field: new_value})
      {:ok, %Legal{}}

      iex> update_legal(legal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_legal(%Legal{} = legal, attrs) do
    legal
    |> Legal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a legal.

  ## Examples

      iex> delete_legal(legal)
      {:ok, %Legal{}}

      iex> delete_legal(legal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_legal(%Legal{} = legal) do
    Repo.delete(legal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking legal changes.

  ## Examples

      iex> change_legal(legal)
      %Ecto.Changeset{data: %Legal{}}

  """
  def change_legal(%Legal{} = legal, attrs \\ %{}) do
    Legal.changeset(legal, attrs)
  end

  @doc """
  Returns the list of seo.

  ## Examples

      iex> list_seo()
      [%Seo{}, ...]

  """
  def list_seo do
    Repo.all(Seo)
  end

  @doc """
  Gets a single seo.

  Raises `Ecto.NoResultsError` if the Seo does not exist.

  ## Examples

      iex> get_seo!(123)
      %Seo{}

      iex> get_seo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seo!(id), do: Repo.get!(Seo, id)

  @doc """
  Creates a seo.

  ## Examples

      iex> create_seo(%{field: value})
      {:ok, %Seo{}}

      iex> create_seo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_seo(attrs \\ %{}) do
    %Seo{}
    |> Seo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a seo.

  ## Examples

      iex> update_seo(seo, %{field: new_value})
      {:ok, %Seo{}}

      iex> update_seo(seo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_seo(%Seo{} = seo, attrs) do
    seo
    |> Seo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a seo.

  ## Examples

      iex> delete_seo(seo)
      {:ok, %Seo{}}

      iex> delete_seo(seo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_seo(%Seo{} = seo) do
    Repo.delete(seo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking seo changes.

  ## Examples

      iex> change_seo(seo)
      %Ecto.Changeset{data: %Seo{}}

  """
  def change_seo(%Seo{} = seo, attrs \\ %{}) do
    Seo.changeset(seo, attrs)
  end

  def generate_tags_and_description(%Images{} = image) do
    image_url = Catalog.imgix_url(image, "photo")

    query_params = %{
      visualfeatures: "Categories,Adult,Tags,Description,Faces,Objects",
      details: "Landmarks"
    }

    case ExAzureVision.analyze(image_url, query_params) do
      {:ok, result} ->
        captions = result["description"]["captions"]

        image_attrs =
          if captions do
            generated_description =
              captions
              |> Enum.max_by(& &1["confidence"])
              |> Map.get("text")

            Map.put(%{}, :generated_description, generated_description)
          else
            %{}
          end

        generated_tags =
          result["tags"]
          |> Enum.filter(fn %{"confidence" => confidence} -> confidence >= 0.5 end)
          |> Enum.map_join(",", fn %{"name" => name} -> name end)

        generated_tags =
          if result["adult"]["isAdultContent"],
            do: generated_tags <> "," <> "nsfw",
            else: generated_tags

        image_attrs =
          image_attrs
          |> Map.put(:generated_tags, generated_tags)

        Multi.new()
        |> Multi.update(:image, Images.changeset(image, image_attrs))
        |> Repo.transaction()

      {:error, reason} ->
        reason
    end
  end
end
