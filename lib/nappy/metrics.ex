defmodule Nappy.Metrics do
  @moduledoc """
  The Metrics context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Nappy.Accounts.UserNotifier
  alias Nappy.Admin
  alias Nappy.Catalog.Images
  alias Nappy.Metrics.ImageAnalytics
  alias Nappy.Metrics.ImageMetadata
  alias Nappy.Metrics.ImageStatus
  alias Nappy.Metrics.LikedImage
  alias Nappy.Repo

  @topic inspect(Nappy.Accounts)

  def notify_subscribers({:ok, image}, event) do
    Phoenix.PubSub.broadcast_from(
      Nappy.PubSub,
      self(),
      @topic <> "#{image.user_id}",
      {__MODULE__, event, image}
    )

    {:ok, image}
  end

  def notify_subscribers({:error, reason}, _event), do: {:error, reason}

  @doc """
  Returns the list of image_status.

  ## Examples

      iex> list_image_status()
      [%ImageStatus{}, ...]

  """
  def list_image_status do
    Repo.all(ImageStatus)
  end

  def status_names do
    Ecto.Enum.values(ImageStatus, :name)
  end

  def get_status_name(status_id) do
    case Repo.get_by(ImageStatus, id: status_id).name do
      :pending -> "pending"
      :active -> "approved"
      :featured -> "approved"
      :denied -> "denied"
    end
  end

  def get_user_status_id(status) do
    # Ecto.Enum.values(User, :status)
    # query =
    #   from is in ImageStatus,
    #     where: is.name == ^status,
    #     select: is.id

    Repo.get_by!(ImageStatus, name: status)
    |> select([i], i.id)

    # Repo.one(query)
  end

  def translate_units(num) do
    kilo = &Float.floor(&1 / 1_000, 1)
    mega = &Float.floor(&1 / 1_000_000, 1)

    cond do
      num < 1_000 ->
        num

      num < 1_000_000 ->
        "#{kilo.(num)}K"

      num >= 1_000_000 ->
        "#{mega.(num)}M"
    end
  end

  def get_profile_page_metrics(user) do
    active = get_image_status_id(:active)
    featured = get_image_status_id(:featured)

    Images
    |> join(:inner, [i], ia in assoc(i, :image_analytics))
    |> where(user_id: ^user.id)
    |> where([i, _], i.image_status_id in ^[active, featured])
    |> select([i, ia], %{
      image_count: count(i.id),
      view_count: type(count(ia.view_count), :integer),
      download_count: type(count(ia.download_count), :integer)
    })
    |> Repo.one()
  end

  @spec approve_images(list(String.t())) :: any()
  def approve_images(slugs) do
    active = get_image_status_id(:active)
    featured = get_image_status_id(:featured)

    images =
      Images
      |> where([i], i.slug in ^slugs)
      |> where([i], i.image_status_id not in ^[active, featured])

    images_id =
      from(i in Images,
        where: i.slug in ^slugs,
        select: i.id
      )
      |> Repo.all()

    image_analytics =
      ImageAnalytics
      |> where([i], i.image_id in ^images_id)

    Multi.new()
    |> Multi.update_all(:approve_image, images, set: [image_status_id: active])
    |> Multi.update_all(:approve_dates, image_analytics,
      set: [approved_date: NaiveDateTime.utc_now()]
    )
    |> multi_run_notify_users(slugs, "approved")
  end

  @spec deny_images(list(String.t())) :: any()
  def deny_images(slugs) do
    denied = get_image_status_id(:denied)

    images =
      Images
      |> where([i], i.slug in ^slugs)
      |> where([i], i.image_status_id != ^denied)

    images_id =
      from(i in Images,
        where: i.slug in ^slugs,
        select: i.id
      )
      |> Repo.all()

    image_analytics =
      ImageAnalytics
      |> where([i], i.image_id in ^images_id)

    Multi.new()
    |> Multi.update_all(:approve_image, images, set: [image_status_id: denied])
    |> Multi.update_all(:set_nil_dates, image_analytics,
      set: [approved_date: nil, featured_date: nil]
    )
    |> multi_run_notify_users(slugs, "denied")
  end

  defp multi_run_notify_users(multi, slugs, status) do
    images =
      Images
      |> where([i], i.slug in ^slugs)
      |> preload(:user)
      |> Repo.all()

    transaction =
      multi
      |> Multi.run(:images, fn _repo, _changes ->
        images
        |> case do
          [] ->
            {:error, :not_found}

          value ->
            value =
              value
              |> Enum.group_by(fn image -> image.user.username end)

            {:ok, value}
        end
      end)
      |> Multi.run(:notify_users, fn _repo, %{images: images} ->
        UserNotifier.notify_uploaded_images_to_users(images, status)

        {:ok, "images #{status}"}
      end)
      |> Repo.transaction()

    case [transaction, status] do
      [{:ok, _}, "approved"] ->
        images
        |> Task.async_stream(
          fn image ->
            notify_subscribers({:ok, image}, "approved")
            Admin.generate_tags_and_description(image)
          end,
          max_concurrency: 12,
          timeout: 100_000
        )
        |> Stream.run()

      [{:error, reason}, _] ->
        reason
    end
  end

  @doc """
  Gets a single image_status.

  Raises `Ecto.NoResultsError` if the Image status does not exist.

  ## Examples

      iex> get_image_status!(123)
      %ImageStatus{}

      iex> get_image_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image_status!(id), do: Repo.get!(ImageStatus, id)

  @doc """
  Get id for the image status. Will return
  cast error since we constrained possible
  values via Ecto.Enum, Please check the
  schema for ImageStatus.

  ## Examples

      iex> get_image_status_id(:active)
      [2]

      iex> get_image_status_id(456)
      ** (Ecto.Query.CastError)

  """
  def get_image_status_id(status) do
    query =
      from is in ImageStatus,
        where: is.name == ^status,
        select: is.id

    Repo.one(query)
  end

  def get_image_status_name(status_id) do
    query =
      from is in ImageStatus,
        where: is.id == ^status_id,
        select: is.name

    Repo.one(query)
  end

  @doc """
  Creates a image_status.

  ## Examples

      iex> create_image_status(%{field: value})
      {:ok, %ImageStatus{}}

      iex> create_image_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image_status(attrs \\ %{}) do
    %ImageStatus{}
    |> ImageStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image_status.

  ## Examples

      iex> update_image_status(image_status, %{field: new_value})
      {:ok, %ImageStatus{}}

      iex> update_image_status(image_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image_status(%ImageStatus{} = image_status, attrs) do
    image_status
    |> ImageStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image_status.

  ## Examples

      iex> delete_image_status(image_status)
      {:ok, %ImageStatus{}}

      iex> delete_image_status(image_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image_status(%ImageStatus{} = image_status) do
    Repo.delete(image_status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image_status changes.

  ## Examples

      iex> change_image_status(image_status)
      %Ecto.Changeset{data: %ImageStatus{}}

  """
  def change_image_status(%ImageStatus{} = image_status, attrs \\ %{}) do
    ImageStatus.changeset(image_status, attrs)
  end

  @doc """
  Returns the list of image_metadata.

  ## Examples

      iex> list_image_metadata()
      [%ImageMetadata{}, ...]

  """
  def list_image_metadata do
    Repo.all(ImageMetadata)
  end

  @doc """
  Get image extension by image ID.

  ## Examples

      iex> get_image_extension(9)
      "jpg"

  """
  def get_image_extension(image_id) do
    query =
      from i in ImageMetadata,
        where: i.image_id == ^image_id,
        select: i.extension_type

    Repo.one(query)
  end

  @doc """
  Gets a single image_metadata.

  Raises `Ecto.NoResultsError` if the Image metadata does not exist.

  ## Examples

      iex> get_image_metadata!(123)
      %ImageMetadata{}

      iex> get_image_metadata!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image_metadata!(id), do: Repo.get!(ImageMetadata, id)

  def get_metadata_by_image_id(image_id) do
    Repo.get_by(ImageMetadata, image_id: image_id)
  end

  @doc """
  Creates a image_metadata.

  ## Examples

      iex> create_image_metadata(%{field: value})
      {:ok, %ImageMetadata{}}

      iex> create_image_metadata(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image_metadata(attrs \\ %{}) do
    %ImageMetadata{}
    |> ImageMetadata.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image_metadata.

  ## Examples

      iex> update_image_metadata(image_metadata, %{field: new_value})
      {:ok, %ImageMetadata{}}

      iex> update_image_metadata(image_metadata, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image_metadata(%ImageMetadata{} = image_metadata, attrs) do
    image_metadata
    |> ImageMetadata.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image_metadata.

  ## Examples

      iex> delete_image_metadata(image_metadata)
      {:ok, %ImageMetadata{}}

      iex> delete_image_metadata(image_metadata)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image_metadata(%ImageMetadata{} = image_metadata) do
    Repo.delete(image_metadata)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image_metadata changes.

  ## Examples

      iex> change_image_metadata(image_metadata)
      %Ecto.Changeset{data: %ImageMetadata{}}

  """
  def change_image_metadata(%ImageMetadata{} = image_metadata, attrs \\ %{}) do
    ImageMetadata.changeset(image_metadata, attrs)
  end

  @doc """
  Returns the list of image_analytics.

  ## Examples

      iex> list_image_analytics()
      [%ImageAnalytics{}, ...]

  """
  def list_image_analytics do
    Repo.all(ImageAnalytics)
  end

  @doc """
  Gets a single image_analytics.

  Raises `Ecto.NoResultsError` if the Image analytics does not exist.

  ## Examples

      iex> get_image_analytics!(123)
      %ImageAnalytics{}

      iex> get_image_analytics!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image_analytics!(id), do: Repo.get!(ImageAnalytics, id)

  def get_image_analytics_by_slug(image_slug) when is_binary(image_slug) do
    Images
    |> where(slug: ^image_slug)
    |> preload(:image_analytics)
    |> Repo.one()
    |> Map.get(:image_analytics)
  end

  @doc """
  Creates a image_analytics.

  ## Examples

      iex> create_image_analytics(%{field: value})
      {:ok, %ImageAnalytics{}}

      iex> create_image_analytics(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image_analytics(attrs \\ %{}) do
    %ImageAnalytics{}
    |> ImageAnalytics.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image_analytics.

  ## Examples

      iex> update_image_analytics(image_analytics, %{field: new_value})
      {:ok, %ImageAnalytics{}}

      iex> update_image_analytics(image_analytics, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image_analytics(%ImageAnalytics{} = image_analytics, attrs) do
    image_analytics
    |> ImageAnalytics.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image_analytics.

  ## Examples

      iex> delete_image_analytics(image_analytics)
      {:ok, %ImageAnalytics{}}

      iex> delete_image_analytics(image_analytics)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image_analytics(%ImageAnalytics{} = image_analytics) do
    Repo.delete(image_analytics)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image_analytics changes.

  ## Examples

      iex> change_image_analytics(image_analytics)
      %Ecto.Changeset{data: %ImageAnalytics{}}

  """
  def change_image_analytics(%ImageAnalytics{} = image_analytics, attrs \\ %{}) do
    ImageAnalytics.changeset(image_analytics, attrs)
  end

  @doc """
  Returns the list of liked_images.

  ## Examples

      iex> list_liked_images()
      [%LikedImage{}, ...]

  """
  def list_liked_images do
    Repo.all(LikedImage)
  end

  @doc """
  Gets a single liked_image.

  Raises `Ecto.NoResultsError` if the Liked image does not exist.

  ## Examples

      iex> get_liked_image!(123)
      %LikedImage{}

      iex> get_liked_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_liked_image!(id), do: Repo.get!(LikedImage, id)

  @doc """
  Creates a liked_image.

  ## Examples

      iex> create_liked_image(%{field: value})
      {:ok, %LikedImage{}}

      iex> create_liked_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_liked_image(attrs \\ %{}) do
    %LikedImage{}
    |> LikedImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a liked_image.

  ## Examples

      iex> update_liked_image(liked_image, %{field: new_value})
      {:ok, %LikedImage{}}

      iex> update_liked_image(liked_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_liked_image(%LikedImage{} = liked_image, attrs) do
    liked_image
    |> LikedImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a liked_image.

  ## Examples

      iex> delete_liked_image(liked_image)
      {:ok, %LikedImage{}}

      iex> delete_liked_image(liked_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_liked_image(%LikedImage{} = liked_image) do
    Repo.delete(liked_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking liked_image changes.

  ## Examples

      iex> change_liked_image(liked_image)
      %Ecto.Changeset{data: %LikedImage{}}

  """
  def change_liked_image(%LikedImage{} = liked_image, attrs \\ %{}) do
    LikedImage.changeset(liked_image, attrs)
  end

  def increment_view_count(%ImageAnalytics{} = image_analytics) do
    {1, [%ImageAnalytics{view_count: view_count}]} =
      ImageAnalytics
      |> where(id: ^image_analytics.id)
      |> select([:view_count])
      |> Repo.update_all(inc: [view_count: 1])

    put_in(image_analytics.view_count, view_count)
  end
end
