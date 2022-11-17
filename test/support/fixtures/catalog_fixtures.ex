defmodule Nappy.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Catalog` context.
  """

  alias Nappy.AccountsFixtures
  alias Nappy.Catalog
  alias Nappy.Metrics

  @doc """
  Generate a image. Do note image_analytics, image_metadata
  and other associations aren't loaded in this fixture.
  """
  def image_fixture(attrs \\ %{}) do
    category = Catalog.get_category_by_name("Other")
    image_status_id = Metrics.get_image_status_id(:pending)
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
        slug: "test_slug",
        tags: "test_tag",
        title: "some title",
        user_id: user.id
      })
      |> Catalog.create_image()

    image
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
    {:ok, collection} =
      attrs
      |> Enum.into(%{})
      |> Nappy.Catalog.create_collection()

    collection
  end

  @doc """
  Generate a collection_description.
  """
  def collection_description_fixture(attrs \\ %{}) do
    {:ok, collection_description} =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_enabled: true,
        title: "some title"
      })
      |> Nappy.Catalog.create_collection_description()

    collection_description
  end
end
