defmodule Nappy.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Catalog` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        description: "some description",
        generated_description: "some generated_description",
        generated_tags: "some generated_tags",
        tags: "some tags",
        title: "some title"
      })
      |> Nappy.Catalog.create_image()

    image
  end

  @doc """
  Generate a image_status.
  """
  def image_status_fixture(attrs \\ %{}) do
    {:ok, image_status} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Nappy.Catalog.create_image_status()

    image_status
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
      |> Nappy.Catalog.create_category()

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

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        unit_price: 120.5
      })
      |> Nappy.Catalog.create_product()

    product
  end
end
