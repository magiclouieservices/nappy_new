defmodule Nappy.Catalog do
  @moduledoc """
  The Catalog context. This is where you
  get images, collections and categories.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias ExAws.S3
  alias Image, as: ExtractImage
  alias Nappy.Accounts.User
  alias Nappy.Accounts.UserNotifier
  alias Nappy.Admin
  alias Nappy.Admin.Slug
  alias Nappy.Catalog
  alias Nappy.Catalog.Category
  alias Nappy.Catalog.Collection
  alias Nappy.Catalog.ImageCollection
  alias Nappy.Metrics
  alias Nappy.Metrics.ImageAnalytics
  alias Nappy.Metrics.ImageMetadata
  alias Nappy.Metrics.ImageStatus
  alias Nappy.Metrics.Notifications
  alias Nappy.Repo
  alias Nappy.SponsoredImages

  @image_status_names Ecto.Enum.values(ImageStatus, :name)
  @full_list_status_names [:all, :popular | @image_status_names]

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Nappy.Catalog.Image{}, ...]

  """
  def list_images(preload \\ []) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> where([i], i.image_status_id in ^[active, featured])
    |> preload(^preload)
    |> Repo.all()
  end

  def get_trend_search_bar do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> where([i], i.image_status_id in ^[active, featured])
    |> order_by(fragment("RANDOM()"))
    |> limit(6)
    |> Repo.all()
  end

  def get_popular_searches do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> join(:inner, [i], ia in assoc(i, :image_analytics))
    |> where([i, _], i.image_status_id in ^[active, featured])
    |> order_by([_, ia], desc: ia.view_count)
    |> distinct([i, _ia], i.id)
    |> limit(20)
    |> Repo.all()
  end

  def get_popular_keywords(max_num_of_keywords) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> join(:inner, [i], ia in assoc(i, :image_analytics))
    |> where([i, _], i.image_status_id in ^[active, featured])
    |> order_by([_, ia], desc: ia.view_count)
    |> limit(^max_num_of_keywords)
    |> select([i, _], i.tags)
    |> Repo.all()
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.take_random(max_num_of_keywords)
  end

  def paginate_images(:popular, params) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Metrics.ImageAnalytics
    |> join(:inner, [ia], i in assoc(ia, :image))
    |> join(:inner, [_, i], u in assoc(i, :user))
    |> join(:inner, [_, i, _], im in assoc(i, :image_metadata))
    |> join(:inner, [_, i, _, _], ia in assoc(i, :image_analytics))
    |> where([_, i, _, _, _], i.image_status_id in ^[active, featured])
    |> order_by([ia, ...], desc: ia.view_count)
    |> select([_, i, u, im, ia], %Nappy.Catalog.Image{
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

  def paginate_images(status_name, params)
      when is_atom(status_name) and
             status_name in @full_list_status_names do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    case status_name do
      :all ->
        Nappy.Catalog.Image
        |> where([i], i.image_status_id in ^[active, featured])

      _ ->
        Nappy.Catalog.Image
        |> where(image_status_id: ^Metrics.get_image_status_id(status_name))
    end
    |> order_by(fragment("RANDOM()"))
    |> preload([:user, :image_metadata, :image_analytics])
    |> Repo.paginate(params)
  end

  def paginate_images(:admin, params) do
    sort_order = params[:sort_order]
    sort_by = params[:sort_by]
    status_name = params[:image_status]

    join_query =
      case status_name do
        :all ->
          Nappy.Catalog.Image

        _ ->
          Nappy.Catalog.Image
          |> where(image_status_id: ^Metrics.get_image_status_id(status_name))
      end
      |> preload([:user, :image_metadata, :image_analytics])
      |> join(:inner, [i], u in assoc(i, :user))
      |> join(:inner, [i, _], im in assoc(i, :image_metadata))
      |> join(:inner, [i, _, _], ia in assoc(i, :image_analytics))

    query =
      case sort_by do
        :user_id ->
          join_query
          |> order_by([_, u, _, _], {^sort_order, u.username})

        :downloads ->
          join_query
          |> order_by([_, _, _, ia], {^sort_order, ia.download_count})

        :views ->
          join_query
          |> order_by([_, _, _, ia], {^sort_order, ia.view_count})

        _ ->
          join_query
          |> preload([:user, :image_metadata, :image_analytics])
          |> order_by({^sort_order, ^sort_by})
      end

    Repo.paginate(query, params)
  end

  def paginate_user_images(username, params) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    User
    |> join(:inner, [u], i in assoc(u, :images))
    |> join(:inner, [_, i], im in assoc(i, :image_metadata))
    |> join(:inner, [_, i, _], ia in assoc(i, :image_analytics))
    |> where([_, i, _, _], i.image_status_id in ^[active, featured])
    |> where(username: ^username)
    |> order_by(fragment("RANDOM()"))
    |> select([u, i, im, ia], %Nappy.Catalog.Image{
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

  def paginate_category(slug, params \\ [page: 1]) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    category_id =
      Category
      |> where(slug: ^slug)
      |> select([c], c.id)
      |> Repo.one()

    Nappy.Catalog.Image
    |> where([i], i.image_status_id in ^[active, featured])
    |> where(category_id: ^category_id)
    |> order_by(fragment("RANDOM()"))
    |> preload([:user, :image_metadata, :image_analytics])
    |> Repo.paginate(params)
  end

  def paginate_collection(slug, params \\ [page: 1]) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    collection_id =
      from(cd in Collection,
        where: cd.slug == ^slug,
        select: cd.id
      )
      |> Repo.one()

    ImageCollection
    |> join(:inner, [c], i in assoc(c, :image))
    |> join(:inner, [_, i], u in assoc(i, :user))
    |> join(:inner, [_, i, _], im in assoc(i, :image_metadata))
    |> join(:inner, [_, i, _, _], ia in assoc(i, :image_analytics))
    |> where([_, i, _, _], i.image_status_id in ^[active, featured])
    |> where(collection_id: ^collection_id)
    # |> order_by(fragment("RANDOM()"))
    |> select([_, i, u, im, ia], %Nappy.Catalog.Image{
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

  def list_collection_images(slug) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    ImageCollection
    |> join(:inner, [image_coll], collection in assoc(image_coll, :collection))
    |> join(:inner, [image_coll, _collection], i in assoc(image_coll, :image))
    |> where([_image_coll, _collection, i], i.image_status_id in ^[active, featured])
    |> where([_image_coll, collection, _], collection.slug == ^slug)
    |> select([_image_coll, _collection, i], %Nappy.Catalog.Image{id: i.id, slug: i.slug})
    |> Repo.all()
  end

  def list_category_images(slug) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Category
    |> join(:inner, [category], i in assoc(category, :images))
    |> where([_category, i], i.image_status_id in ^[active, featured])
    |> where([category, _i], category.slug == ^slug)
    |> select([_category, i], %Nappy.Catalog.Image{id: i.id, slug: i.slug})
    |> Repo.all()
  end

  @spec insert_adverts_in_paginated_images(String.t(), mfa :: {module(), atom(), list(any())}) ::
          Scrivener.Page.t()
  def insert_adverts_in_paginated_images(payload_name, mfa) do
    {mod, func_name, [name, [page: page, page_size: page_size]] = args} = mfa
    payload_name = "#{payload_name}_#{name}"
    ttl = :timer.hours(1)

    images =
      if page === 1 do
        args = [name, [page: page, page_size: page_size]]
        mfa = {mod, func_name, args}

        Nappy.Caching.paginated_images_payload(mfa, payload_name, ttl)
      else
        apply(mod, func_name, args)
      end

    sponsored_search_terms = get_popular_keywords(4)
    sponsored = SponsoredImages.get_images("image_adverts_#{page}", sponsored_search_terms, 4)

    if Enum.empty?(sponsored) do
      images
    else
      index_pos = length(images.entries) - 1
      # if page === 1,
      #   do: length(images.entries) - 1,
      #   else: Enum.random(7..length(images.entries))

      entries = List.insert_at(images.entries, index_pos, %{sponsored: sponsored})
      Map.put(images, :entries, entries)
    end
  end

  def image_url_by_id(uuid) do
    image = get_image!(uuid)

    imgix_url(image, "photo")
  end

  def create_shareable_links("share_url", slug) do
    share_host = Nappy.nappy_host()
    path = Path.join(["/", "photo", slug])
    image_url(share_host, path)
  end

  def create_shareable_links("photo_link", slug) do
    embed_host = Nappy.embed_host()
    path = Path.join(["/", "photo", slug])
    image_url(embed_host, path)
  end

  def create_shareable_links("embed_url", slug) do
    embed_host = Nappy.embed_host()
    path = Path.join(["/", "photo", slug])
    photo_link = image_url(embed_host, path)
    Phoenix.HTML.html_escape(~s(<img src="#{photo_link}">))
  end

  def embed_url(slug, query \\ nil)

  def embed_url("random", query) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> order_by(fragment("RANDOM()"))
    |> where([i], i.image_status_id in ^[active, featured])
    |> limit(1)
    |> Repo.one()
    |> imgix_url("photo", query)
  end

  def embed_url(slug, query) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> where(slug: ^slug)
    |> where([i], i.image_status_id in ^[active, featured])
    |> limit(1)
    |> Repo.one()
    |> imgix_url("photo", query)
  end

  def imgix_url_by_id(image_id, query \\ nil) do
    get_image!(image_id)
    |> imgix_url("photo", query)
  end

  def imgix_url(%Nappy.Catalog.Image{} = image, type, query \\ nil) do
    ext = Metrics.get_image_extension(image.id) || "jpg"
    filename = "#{image.slug}.#{ext}"
    host = Nappy.image_src_host()
    path = Path.join(["/", type, filename])

    query =
      if query do
        query
      else
        %{
          cs: "tinysrgb",
          fm: "avif",
          w: default_imgix_width(),
          h: default_imgix_height()
        }
      end

    image_url(host, path, URI.encode_query(query))
  end

  def default_imgix_width, do: 1260
  def default_imgix_height, do: 750

  def image_url(host, path \\ nil, query \\ nil) do
    uri = %URI{
      scheme: "https",
      host: host,
      path: path,
      query: query
    }

    URI.to_string(uri)

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
      %Nappy.Catalog.Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Nappy.Catalog.Image, id)

  @doc """
  Get an Image based from slug. Do note that
  it gets all images regardless of status.

  ## Examples

      iex> get_image_by_slug("12345abcdefg", [preload: [:user], select: [:title]])
      %Nappy.Catalog.Image{}

      iex> get_image_by_slug("12345abcdefg", [preload: [:user]])
      %Nappy.Catalog.Image{}

      iex> get_image_by_slug("don't exists")
      nil

  """
  def get_image_by_slug(slug, opts \\ [preload: [], select: nil])
      when is_binary(slug) do
    if opts[:select] do
      select(Nappy.Catalog.Image, ^opts[:select])
    else
      select(Nappy.Catalog.Image, [i], i)
    end
    |> where(slug: ^slug)
    |> preload(^opts[:preload])
    |> Repo.one()
  end

  def get_related_images(slug) do
    image = Repo.get_by!(Nappy.Catalog.Image, slug: slug)

    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    tag = Enum.take_random(image.tags, 1)

    related_images =
      Nappy.Catalog.Image
      |> where([i], i.id != ^image.id)
      |> where(category_id: ^image.category_id)
      |> where([i], i.image_status_id in ^[active, featured])

    related_images
    |> where([i], like(i.tags, ^"%#{tag}%"))
    |> order_by(fragment("RANDOM()"))
    |> limit(5)
    |> Repo.aggregate(:count, :id)
    |> Kernel.<(5)
    |> case do
      true ->
        related_images
        |> order_by(fragment("RANDOM()"))
        |> limit(5)
        |> Repo.all()

      false ->
        related_images
        |> where([i], like(i.tags, ^"%#{tag}%"))
        |> order_by(fragment("RANDOM()"))
        |> limit(5)
        |> Repo.all()
    end
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Nappy.Catalog.Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    Repo.transaction(fn ->
      {:ok, _} = Carbonite.insert_transaction(Repo, %{meta: %{type: "image_inserted"}})

      created_image =
        %Catalog.Image{}
        |> Catalog.Image.changeset(attrs)
        |> Repo.insert!()

      stringify = fn bitstring ->
        bitstring
        |> to_charlist()
        |> Enum.filter(&(&1 !== 0))
        |> to_string()
      end

      {:ok, image} = ExtractImage.open(attrs.path)

      image_metadata_attrs =
        case ExtractImage.exif(image) do
          {:ok, data} ->
            {:ok, stat} = File.stat(attrs.path)

            model = stringify.(data.model)
            camera_software = stringify.(data.software)

            %{
              image_id: created_image.id,
              extension_type: attrs.ext,
              height: data.exif.exif_image_height,
              width: data.exif.exif_image_width,
              # converts to float
              file_size: stat.size * 1.0,
              focal: data.exif.focal_length,
              aperture: data.exif.f_number,
              camera_software: camera_software,
              device_model: model,
              iso: data.exif.iso_speed_ratings,
              shutter_speed: data.exif.exposure_time
              # color_palette:
            }

          {:error, _reason} ->
            {:ok, stat} = File.stat(attrs.path)

            %{
              image_id: created_image.id,
              extension_type: attrs.ext,
              height: ExtractImage.height(image),
              width: ExtractImage.width(image),
              # converts to float
              file_size: stat.size * 1.0
            }
        end

      created_image
      |> Ecto.build_assoc(:image_metadata, image_metadata_attrs)
      |> ImageMetadata.changeset(image_metadata_attrs)
      |> Repo.insert()

      created_image
      |> Ecto.build_assoc(:image_analytics, %{})
      |> ImageAnalytics.changeset(%{})
      |> Repo.insert()

      created_image =
        created_image
        |> Repo.preload(:user)

      %{created_image.user.username => [created_image]}
      |> UserNotifier.notify_uploaded_images_to_users("pending")

      created_image
    end)
  end

  def zoomed_image(%Nappy.Catalog.Image{} = image, "w") do
    width = image.image_metadata.width
    round(width * 0.45)
  end

  def zoomed_image(%Nappy.Catalog.Image{} = image, "h") do
    height = image.image_metadata.height
    round(height * 0.45)
  end

  def list_scaled_images(width, height) do
    resolution = fn scale ->
      %{
        "width" => round(width * scale),
        "height" => round(height * scale)
      }
    end

    if width < 1600 do
      [
        original: resolution.(1)
      ]
    else
      [
        small: resolution.(0.5),
        medium: resolution.(0.65),
        large: resolution.(0.8),
        original: resolution.(1)
      ]
    end
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Nappy.Catalog.Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Nappy.Catalog.Image{} = image, attrs) do
    image
    |> Catalog.Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates an image via admin images page.

  ## Examples
      iex> params = %{
        "category" => category,
        "featured" => featured,
        "input-tags" => tags,
        "title" => title,
        "slug" => slug
      } = params,

      iex> admin_update_image(params)
      {:ok, %Nappy.Catalog.Image{}}
  """
  def admin_update_image(params) do
    category = params["category"]
    is_featured = params["featured"]
    slug = params["slug"]
    tags = params["input-tags"]
    title = params["title"]

    image = get_image_by_slug(slug)

    category = get_category_by_name(category)
    featured = Metrics.get_image_status_id(:featured)
    denied = Metrics.get_image_status_id(:denied)

    image_status_id =
      if is_featured === "yes" && image.image_status_id !== featured do
        featured
      else
        Metrics.get_image_status_id(:active)
      end

    tags =
      tags
      |> Jason.decode!()
      |> Enum.map_join(",", &Map.values/1)

    image_attrs = %{
      title: title,
      category_id: category.id,
      image_status_id: image_status_id,
      slug: image.slug,
      tags: tags,
      user_id: image.user_id
    }

    image_analytics = Metrics.get_image_analytics_by_slug(slug)

    featured_date =
      if is_featured === "yes" do
        NaiveDateTime.utc_now()
      else
        image_analytics.featured_date
      end

    image_analytics_attrs = %{
      image_id: image_analytics.image_id,
      featured_date: featured_date
    }

    if image.image_status_id === denied do
      {:error, "status is denied"}
    else
      Multi.new()
      |> Carbonite.Multi.insert_transaction(%{meta: %{type: "image_updated"}})
      |> Multi.update(
        :image_analytics,
        ImageAnalytics.changeset(image_analytics, image_analytics_attrs)
      )
      |> Multi.update(:image, Catalog.Image.changeset(image, image_attrs))
      |> Multi.run(:notify_user, fn repo, %{image: image} ->
        image =
          image
          |> repo.preload(:user)

        if image.image_status_id === featured do
          %{image.user.username => [image]}
          |> UserNotifier.notify_uploaded_images_to_users("featured")
        end

        if is_nil(image.generated_tags) or Enum.empty?(image.generated_tags) do
          {:ok, _} = Admin.generate_tags_and_description(image)
        end

        {:ok, _} = ExTypesense.update_document(image)

        {:ok, image}
      end)
      |> Repo.transaction()
    end
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Nappy.Catalog.Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Nappy.Catalog.Image{} = image, bucket_name \\ Nappy.bucket_name()) do
    Repo.transaction(fn ->
      {:ok, _} = Carbonite.insert_transaction(Repo, %{meta: %{type: "image_deleted"}})

      ext = Metrics.get_image_extension(image.id)
      filename = "#{image.slug}.#{ext}"
      path = Path.join(["photos", filename])

      Notifications
      |> where(additional_foreign_key: ^image.id)
      |> Repo.one()
      |> Repo.delete!()

      Repo.delete!(image)

      bucket_name
      |> S3.delete_object(path)
      |> ExAws.request!()
    end)
  end

  def delete_multiple_images(slugs, bucket_name \\ Nappy.bucket_name()) do
    images =
      Nappy.Catalog.Image
      |> where([i], i.slug in ^slugs)

    objects =
      images
      |> Repo.all()
      |> Enum.map(fn image ->
        ext = Metrics.get_image_extension(image.id)
        "photos/#{image.slug}.#{ext}"
      end)

    transaction =
      Multi.new()
      |> Carbonite.Multi.insert_transaction(%{meta: %{type: "image_deleted"}})
      |> Multi.delete_all(:remove_images, images)
      |> Multi.run(:delete_s3_objects, fn _repo, _changes ->
        bucket_name
        |> S3.delete_multiple_objects(objects)
        |> ExAws.request()
      end)
      |> Repo.transaction()

    with {:ok, _} <- transaction do
      images
      |> Repo.all()
      |> Enum.each(&ExTypesense.delete_document/1)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Nappy.Catalog.Image{}}

  """
  def change_image(%Nappy.Catalog.Image{} = image, attrs \\ %{}) do
    Catalog.Image.changeset(image, attrs)
  end

  def image_tags_as_list(tags, generated_tags) do
    List.flatten(tags, generated_tags || [])
    |> Enum.uniq()
  end

  @spec single_upload(String.t(), map()) :: [String.t()]
  def single_upload(bucket_name, params, image_status \\ :pending)
      when image_status in @full_list_status_names do
    do_upload(bucket_name, params, image_status)
  end

  @spec bulk_upload(String.t(), map()) :: [String.t()]
  def bulk_upload(bucket_name, params, image_status \\ :pending)
      when image_status in @full_list_status_names do
    do_upload(bucket_name, params, image_status, 10)
  end

  defp do_upload(bucket_name, params, image_status, concurrency \\ 1) do
    upload = fn {slug, field} ->
      image_status_id = Metrics.get_image_status_id(image_status)
      category = get_category_by_name(field.category)

      attrs = %{
        category_id: category.id,
        dest: field.dest,
        ext: field.ext,
        image_status_id: image_status_id,
        path: field.source,
        slug: slug,
        title: field.title,
        tags: field.tags,
        user_id: field.user_id
      }

      with {:ok, image} <- create_image(attrs) do
        field.source
        |> S3.Upload.stream_file()
        |> S3.upload(bucket_name, field.dest)
        |> ExAws.request()

        image
      end
    end

    input_file = if is_struct(params.file), do: [params.file], else: params.file

    paths =
      Enum.reduce(input_file, %{}, fn f, acc ->
        slug = Nanoid.generate()

        <<".", ext::binary>> =
          case Map.get(f, :filename) do
            nil ->
              Path.extname(f.client_name)

            _ ->
              Path.extname(f.filename)
          end

        src_path =
          case Map.get(f, :path) do
            nil ->
              params.path

            _ ->
              f.path
          end

        dest_path = "photo/#{slug}.#{ext}"

        params = %{
          category: params.category,
          dest: dest_path,
          ext: ext,
          source: src_path,
          tags: params.tags,
          title: params.title,
          user_id: params.user_id
        }

        Map.put(acc, slug, params)
      end)

    paths
    |> Task.async_stream(upload, max_concurrency: concurrency, timeout: 600_000)
    |> Stream.run()

    Enum.map(paths, fn {slug, _field} -> slug end)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_all_category_names do
    from(c in Category, select: c.name)
    |> Repo.all()
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

  @doc """
  Gets a single category by a field.

  Returns `nil` if the Category does not exist.

  ## Examples

      iex> get_category(id: 123)
      %Category{}

      iex> get_category(slug: "456")
      nil

  """
  def get_category(field), do: Repo.get_by(Category, field)

  def get_category_by_slug(slug) do
    Category
    |> where(slug: ^slug)
    |> Repo.one()
  end

  def get_category_by_name(category_name) do
    Category
    |> where([c], ilike(c.name, ^category_name))
    |> where([c], c.is_enabled == ^true)
    |> Repo.one()
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
    |> Repo.insert!()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(attrs) do
    category = get_category_by_slug(attrs.slug)

    attrs =
      if Map.has_key?(attrs, :name) do
        %{attrs | slug: Slug.slugify(attrs.name)}
      else
        attrs
      end

    update_category(category, attrs)
  end

  def update_category(category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update!()
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
  Returns the list of collections.

  ## Examples

      iex> list_collections()
      [%Collection{}, ...]

  """
  def list_collections do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    images = Nappy.Catalog.Image |> where([i], i.image_status_id in ^[active, featured])

    Collection
    |> preload(images: ^images)
    |> Repo.all()
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if a Collection does not exist.

  ## Examples

      iex> get_collection!(123)
      %Collection{}

      iex> get_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id), do: Repo.get!(Collection, id)

  def get_collection_by_slug(slug) do
    Collection
    |> where(slug: ^slug)
    |> preload(:user)
    |> Repo.one()
  end

  def get_collection_by_user_id(user_id) do
    Collection
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def get_matched_collection(collection_id, image_id) do
    collections =
      Collection
      |> where(id: ^collection_id)
      |> select([c], c.id)

    Nappy.Catalog.Image
    |> where(id: ^image_id)
    |> preload(collections: ^collections)
    |> Repo.one()
  end

  def consolidate_tags_by_category(category_id, count \\ 24) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> where([i], i.image_status_id in ^[active, featured])
    |> where(category_id: ^category_id)
    |> randomize_and_flatten(3, count)
  end

  @doc """
  Related tags by group of images
  """
  @spec consolidate_tags_by_collection(String.t(), integer()) :: [String.t()]
  def consolidate_tags_by_collection(slug, count \\ 24) do
    images = Nappy.Catalog.Image |> select([:tags])

    Collection
    |> where(slug: ^slug)
    |> preload(images: ^images)
    |> randomize_and_flatten(3, count)
  end

  def random_tags(count \\ 24) do
    active = Metrics.get_image_status_id(:active)
    featured = Metrics.get_image_status_id(:featured)

    Nappy.Catalog.Image
    |> where([i], i.image_status_id in ^[active, featured])
    |> randomize_and_flatten(3, count)
  end

  defp randomize_and_flatten(query, limit, count) do
    query
    |> order_by(fragment("RANDOM()"))
    |> select([i], i.tags)
    |> limit(^limit)
    |> Repo.all()
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.take_random(count)
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(attrs) do
    collection =
      Collection
      |> where(slug: ^attrs.slug)
      |> Repo.one()

    attrs =
      if Map.has_key?(attrs, :title),
        do: Map.put(attrs, :slug, Slug.slugify(attrs.title)),
        else: attrs

    update_collection(collection, attrs)
  end

  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update!()
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
    Repo.transaction(fn ->
      Repo.delete(collection)
    end)
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

  def truncate_related_tags(related_tag) do
    if String.length(related_tag) > 13 do
      String.slice(related_tag, 0..12) <> "..."
    else
      related_tag
    end
  end

  def set_image_to_existing_collections(collection_slugs, image_slug, attrs \\ %{}) do
    image_id = Nappy.Catalog.Image |> where(slug: ^image_slug) |> select([i], i.id) |> Repo.one()

    collections =
      Collection
      |> where([c], c.slug in ^collection_slugs)
      |> where(user_id: ^attrs.user_id)

    collection =
      Collection
      |> join(:left, [c], ic in ImageCollection, on: c.id == ic.collection_id)
      |> join(:left, [_c, ic], i in Nappy.Catalog.Image, on: ic.image_id == i.id)

    remove_image_collection_id =
      collection
      |> where([c, _ic, _i], c.slug not in ^collection_slugs)
      |> where([_c, _ic, i], i.slug == ^image_slug)
      |> select([c, _ic, _i], c.id)
      |> Repo.all()

    image =
      Nappy.Catalog.Image
      |> preload(:collections)
      |> where(slug: ^image_slug)
      |> Repo.one()

    Repo.transaction(fn ->
      ImageCollection
      |> where([ic], ic.collection_id in ^remove_image_collection_id)
      |> where(image_id: ^image_id)
      |> Repo.delete_all()

      map =
        collection
        |> where([c], c.id in ^remove_image_collection_id)
        |> preload(images: ^from(i in Nappy.Catalog.Image, limit: 1, select: i.id))
        |> Repo.all()
        |> Enum.filter(&Enum.empty?(&1.images))
        |> Enum.map(&{&1.slug, &1.id})
        |> Map.new()

      remove_collection_ids = Map.values(map)

      Collection
      |> where([c], c.id in ^remove_collection_ids)
      |> Repo.delete_all()

      image
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:collections, Repo.all(collections))
      |> Repo.update!()

      Map.keys(map)
    end)
  end

  def add_image_to_new_collection(image_slug, attrs \\ %{}) do
    image =
      Nappy.Catalog.Image
      |> where(slug: ^image_slug)
      |> Repo.one()

    slug = Slug.slugify(attrs.title)

    attrs =
      attrs
      |> Map.put(:image_id, image.id)
      |> Map.put(:slug, slug)
      |> Map.put(:is_enabled, true)

    Repo.transaction(fn ->
      %{id: collection_id} =
        %Collection{}
        |> Collection.changeset(attrs)
        |> Repo.insert!()

      Collection
      |> where(id: ^collection_id)
      |> preload(:images)
      |> Repo.one()
      |> Collection.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:images, [image | []])
      |> Repo.update!()
    end)
  end
end
