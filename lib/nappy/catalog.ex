defmodule Nappy.Catalog do
  @moduledoc """
  The Catalog context. This is where you
  get images, collections and categories.
  """

  import Ecto.Query, warn: false
  alias Nappy.Catalog.Images
  alias Nappy.Metrics
  alias Nappy.Repo

  @image_status_names [:all, :popular | Ecto.Enum.values(Metrics.ImageStatus, :name)]

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Images{}, ...]

  """
  def list_images(preload \\ []) do
    Images
    |> where(image_status_id: ^Metrics.get_image_status_id(:active))
    |> or_where(image_status_id: ^Metrics.get_image_status_id(:featured))
    |> preload(^preload)
    |> Repo.all()
  end

  def paginate_images(:popular, params) do
    Nappy.Metrics.ImageAnalytics
    |> join(:inner, [ia], i in assoc(ia, :image))
    |> join(:inner, [_, i], u in assoc(i, :user))
    |> join(:inner, [_, i, _], im in assoc(i, :image_metadata))
    |> where([_, i], i.image_status_id == ^Metrics.get_image_status_id(:active))
    |> or_where([_, i], i.image_status_id == ^Metrics.get_image_status_id(:featured))
    |> order_by([ia, ...], desc: ia.view_count)
    |> select([_, i, u, im], %Images{
      id: i.id,
      description: i.description,
      generated_description: i.generated_description,
      generated_tags: i.generated_tags,
      slug: i.slug,
      tags: i.tags,
      title: i.title,
      category_id: i.category_id,
      image_metadata: im,
      image_status_id: i.image_status_id,
      user_id: u.id,
      user: u,
      inserted_at: i.inserted_at,
      updated_at: i.updated_at
    })
    |> Repo.paginate(params)
  end

  def paginate_images(status_name, params)
      when is_atom(status_name) and
             status_name in @image_status_names do
    case status_name do
      :all ->
        Images
        |> where(image_status_id: ^Metrics.get_image_status_id(:active))
        |> or_where(image_status_id: ^Metrics.get_image_status_id(:featured))

      _ ->
        Images
        |> where(image_status_id: ^Metrics.get_image_status_id(status_name))
    end
    |> order_by(fragment("RANDOM()"))
    |> preload([:user, :image_metadata])
    |> Repo.paginate(params)
  end

  def image_url_by_id(uuid, opts \\ []) do
    image = get_image!(uuid)

    image_url(image, opts)
  end

  def image_url(%Images{} = image, opts \\ []) do
    ext = Metrics.get_image_extension(image.id)
    base_url = Nappy.embed_url()
    path = Nappy.image_paths("approved")
    filename = "#{image.slug}.#{ext}"

    if opts !== [] do
      imgix_query = URI.encode_query(opts)
      "#{base_url}#{path}#{filename}?#{imgix_query}"
    else
      "#{base_url}#{path}#{filename}"
    end

    # <img
    #   srcset="https://assets.imgix.net/examples/bluehat.jpg?w=400&dpr=1 1x,
    #           https://assets.imgix.net/examples/bluehat.jpg?w=400&fit=max&q=40&dpr=2 2x,
    #           https://assets.imgix.net/examples/bluehat.jpg?w=400&fit=max&q=20&dpr=3 3x"
    #   src="https://assets.imgix.net/examples/bluehat.jpg?w=400"
    # >
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Images{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Images, id)

  @doc """
  Get an Image based from slug

  ## Examples

      iex> get_image_by_slug("12345abcdefg", [preload: [:user], select: [:title]])
      %Images{}

      iex> get_image_by_slug("12345abcdefg", [preload: [:user]])
      %Images{}

      iex> get_image_by_slug("don't exists")
      Ecto.NoResultsError

  """
  def get_image_by_slug(slug, opts \\ [preload: [], select: nil])
      when is_binary(slug) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    if opts[:select] do
      select(Images, ^opts[:select])
    else
      select(Images, [i], i)
    end
    |> where(image_status_id: ^active)
    |> or_where(image_status_id: ^featured)
    |> where(slug: ^slug)
    |> preload(^opts[:preload])
    |> Repo.one()
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Images{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    %Images{}
    |> Images.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Images{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Images{} = image, attrs) do
    image
    |> Images.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Images{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Images{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Images{}}

  """
  def change_image(%Images{} = image, attrs \\ %{}) do
    Images.changeset(image, attrs)
  end

  def image_tags_as_list(tags, generated_tags) do
    tags = String.split(tags, ",", trim: true)

    generated_tags =
      if is_nil(generated_tags) do
        []
      else
        String.split(generated_tags, ",", trim: true)
      end

    List.flatten(tags, generated_tags)
    |> Enum.uniq()
  end

  alias Nappy.Catalog.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def paginate_category(slug, params \\ [page: 1]) do
    category_id =
      Category
      |> where(slug: ^slug)
      |> select([c], c.id)
      |> Repo.one()

    Images
    |> where(image_status_id: ^Metrics.get_image_status_id(:active))
    |> or_where(image_status_id: ^Metrics.get_image_status_id(:featured))
    |> where(category_id: ^category_id)
    |> order_by(fragment("RANDOM()"))
    |> preload([:user, :image_metadata])
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_category_by_name(category_name) do
    query =
      from c in Category,
        where: c.name == ^category_name,
        where: c.is_enabled == ^true,
        select: c.id

    Repo.one(query)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias Nappy.Catalog.Collection

  @doc """
  Returns the list of collections.

  ## Examples

      iex> list_collections()
      [%Collection{}, ...]

  """
  def list_collections do
    Repo.all(Collection)
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection!(123)
      %Collection{}

      iex> get_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id), do: Repo.get!(Collection, id)

  @doc """
  Creates a collection.

  ## Examples

      iex> create_collection(%{field: value})
      {:ok, %Collection{}}

      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collection.

  ## Examples

      iex> delete_collection(collection)
      {:ok, %Collection{}}

      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.

  ## Examples

      iex> change_collection(collection)
      %Ecto.Changeset{data: %Collection{}}

  """
  def change_collection(%Collection{} = collection, attrs \\ %{}) do
    Collection.changeset(collection, attrs)
  end

  alias Nappy.Catalog.CollectionDescription

  @doc """
  Returns the list of collection_description.

  ## Examples

      iex> list_collection_description()
      [%CollectionDescription{}, ...]

  """
  def list_collection_description do
    image_query =
      Images
      |> where(image_status_id: ^Metrics.get_image_status_id(:active))
      |> or_where(image_status_id: ^Metrics.get_image_status_id(:featured))

    collection_query =
      Collection
      |> preload(image: ^image_query)
      |> order_by(fragment("RANDOM()"))

    CollectionDescription
    |> preload(collections: ^collection_query)
    |> Repo.all()
  end

  @doc """
  Gets a single collection_description.

  Raises `Ecto.NoResultsError` if the Collection description does not exist.

  ## Examples

      iex> get_collection_description!(123)
      %CollectionDescription{}

      iex> get_collection_description!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection_description!(id), do: Repo.get!(CollectionDescription, id)

  def get_collection_description_by_slug(slug) do
    CollectionDescription
    |> where(slug: ^slug)
    |> limit(1)
    |> preload(:user)
    |> Repo.one()
  end

  def paginate_collection(slug, params \\ [page: 1]) do
    coll_desc_id =
      from(cd in CollectionDescription,
        where: cd.slug == ^slug,
        select: cd.id
      )
      |> Repo.one()

    Collection
    |> join(:inner, [c], i in assoc(c, :image))
    |> join(:inner, [_, i], u in assoc(i, :user))
    |> join(:inner, [_, i, _], im in assoc(i, :image_metadata))
    |> where([_, i], i.image_status_id == ^Metrics.get_image_status_id(:active))
    |> or_where([_, i], i.image_status_id == ^Metrics.get_image_status_id(:featured))
    |> where(collection_description_id: ^coll_desc_id)
    |> order_by(fragment("RANDOM()"))
    |> select([_, i, u, im], %Images{
      id: i.id,
      description: i.description,
      generated_description: i.generated_description,
      generated_tags: i.generated_tags,
      slug: i.slug,
      tags: i.tags,
      title: i.title,
      category_id: i.category_id,
      image_metadata: im,
      image_status_id: i.image_status_id,
      user_id: u.id,
      user: u,
      inserted_at: i.inserted_at,
      updated_at: i.updated_at
    })
    |> Repo.paginate(params)
  end

  @doc """
  Creates a collection_description.

  ## Examples

      iex> create_collection_description(%{field: value})
      {:ok, %CollectionDescription{}}

      iex> create_collection_description(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection_description(attrs \\ %{}) do
    %CollectionDescription{}
    |> CollectionDescription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection_description.

  ## Examples

      iex> update_collection_description(collection_description, %{field: new_value})
      {:ok, %CollectionDescription{}}

      iex> update_collection_description(collection_description, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection_description(%CollectionDescription{} = collection_description, attrs) do
    collection_description
    |> CollectionDescription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collection_description.

  ## Examples

      iex> delete_collection_description(collection_description)
      {:ok, %CollectionDescription{}}

      iex> delete_collection_description(collection_description)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection_description(%CollectionDescription{} = collection_description) do
    Repo.delete(collection_description)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection_description changes.

  ## Examples

      iex> change_collection_description(collection_description)
      %Ecto.Changeset{data: %CollectionDescription{}}

  """
  def change_collection_description(
        %CollectionDescription{} = collection_description,
        attrs \\ %{}
      ) do
    CollectionDescription.changeset(collection_description, attrs)
  end
end
