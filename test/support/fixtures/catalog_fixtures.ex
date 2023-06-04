defmodule Nappy.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Catalog` context.
  """

  alias Nappy.AccountsFixtures
  alias Nappy.Catalog
  alias Nappy.Metrics

  @image_status_names Ecto.Enum.values(Metrics.ImageStatus, :name)

  @doc """
  Generate a image. Do note image_analytics, image_metadata
  and other associations aren't loaded in this fixture.
  """
  def image_fixture(attrs \\ %{}, image_status \\ :pending)
      when image_status in [:pending, :active, :denied, :featured] do
    category = Catalog.get_category_by_name("Other")
    image_status_id = Metrics.get_image_status_id(image_status)
    user = AccountsFixtures.user_fixture()

    {:ok, image} =
      attrs
      |> Enum.into(%{
        category_id: category.id,
        description: "some description",
        ext: "jpg",
        image_status_id: image_status_id,
        generated_description: "some generated_description",
        generated_tags: "some generated_tags",
        path: File.cwd!() |> Path.join("priv/static/images/image.jpg"),
        slug: attrs[:slug] || "test_slug",
        tags: attrs[:tags] || "test_tag",
        title: "some title",
        user_id: user.id
      })
      |> Catalog.create_image()

    image
  end

  def paginate_images(filter, params) do
    Catalog.paginate_images(filter, params)
  end

  def uploaded_image_fixture(bucket_name, image_status \\ :pending)
      when image_status in @image_status_names do
    user = AccountsFixtures.user_fixture()

    bucket_name
    |> ExAws.S3.put_bucket("us-east-1")
    |> ExAws.request()

    params =
      %{
        category: "Other",
        file: %Plug.Upload{
          path: File.cwd!() |> Path.join("priv/static/images/image.jpg"),
          content_type: "image/jpeg",
          filename: "image.jpg"
        },
        tags: "test,testpic",
        title: "test image"
      }
      |> Map.put(:user_id, user.id)

    bucket_name
    |> Catalog.single_upload(params, image_status)
    |> hd()
    |> Catalog.get_image_by_slug()
  end

  @doc """
  Generate a unique category slug.
  """
  def unique_category_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        is_enabled: true,
        name: "some name",
        slug: unique_category_slug(),
        thumbnail: "some thumbnail"
      })
      |> Catalog.create_category()

    category
  end

  @doc """
  Generate a collection.
  """
  def collection_fixture(attrs \\ %{}) do
    image = image_fixture(%{}, :active)

    {:ok, collection} =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_enabled: true,
        title: attrs[:title] || "some title",
        slug: attrs[:slug] || "coll-desc",
        user_id: image.user_id,
        thumbnail: image.id
      })
      |> Nappy.Catalog.create_collection()

    collection =
      collection
      |> Nappy.Repo.preload(:images)

    collection
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:images, [image | collection.images])
    |> Nappy.Repo.update!()
  end
end
