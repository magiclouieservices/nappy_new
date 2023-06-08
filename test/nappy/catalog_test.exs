defmodule Nappy.CatalogTest do
  use Nappy.DataCase

  alias Nappy.Catalog

  describe "images" do
    alias Nappy.Catalog.Image

    import Nappy.CatalogFixtures

    @invalid_attrs %{
      description: nil,
      generated_description: nil,
      generated_tags: nil,
      tags: nil,
      title: nil
    }

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Catalog.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Catalog.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{
        description: "some description",
        generated_description: "some generated_description",
        generated_tags: "some generated_tags",
        tags: "some tags",
        title: "some title"
      }

      assert {:ok, %Image{} = image} = Catalog.create_image(valid_attrs)
      assert image.description == "some description"
      assert image.generated_description == "some generated_description"
      assert image.generated_tags == "some generated_tags"
      assert image.tags == "some tags"
      assert image.title == "some title"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()

      update_attrs = %{
        description: "some updated description",
        generated_description: "some updated generated_description",
        generated_tags: "some updated generated_tags",
        tags: "some updated tags",
        title: "some updated title"
      }

      assert {:ok, %Image{} = image} = Catalog.update_image(image, update_attrs)
      assert image.description == "some updated description"
      assert image.generated_description == "some updated generated_description"
      assert image.generated_tags == "some updated generated_tags"
      assert image.tags == "some updated tags"
      assert image.title == "some updated title"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_image(image, @invalid_attrs)
      assert image == Catalog.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Catalog.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Catalog.change_image(image)
    end
  end

  describe "image_status" do
    alias Nappy.Catalog.ImageStatus

    import Nappy.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_image_status/0 returns all image_status" do
      image_status = image_status_fixture()
      assert Catalog.list_image_status() == [image_status]
    end

    test "get_image_status!/1 returns the image_status with given id" do
      image_status = image_status_fixture()
      assert Catalog.get_image_status!(image_status.id) == image_status
    end

    test "create_image_status/1 with valid data creates a image_status" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %ImageStatus{} = image_status} = Catalog.create_image_status(valid_attrs)
      assert image_status.name == "some name"
    end

    test "create_image_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_image_status(@invalid_attrs)
    end

    test "update_image_status/2 with valid data updates the image_status" do
      image_status = image_status_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %ImageStatus{} = image_status} =
               Catalog.update_image_status(image_status, update_attrs)

      assert image_status.name == "some updated name"
    end

    test "update_image_status/2 with invalid data returns error changeset" do
      image_status = image_status_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalog.update_image_status(image_status, @invalid_attrs)

      assert image_status == Catalog.get_image_status!(image_status.id)
    end

    test "delete_image_status/1 deletes the image_status" do
      image_status = image_status_fixture()
      assert {:ok, %ImageStatus{}} = Catalog.delete_image_status(image_status)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_image_status!(image_status.id) end
    end

    test "change_image_status/1 returns a image_status changeset" do
      image_status = image_status_fixture()
      assert %Ecto.Changeset{} = Catalog.change_image_status(image_status)
    end
  end

  describe "categories" do
    alias Nappy.Catalog.Category

    import Nappy.CatalogFixtures

    @invalid_attrs %{is_enabled: nil, name: nil, slug: nil, thumbnail: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Catalog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Catalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{
        is_enabled: true,
        name: "some name",
        slug: "some slug",
        thumbnail: "some thumbnail"
      }

      assert {:ok, %Category{} = category} = Catalog.create_category(valid_attrs)
      assert category.is_enabled == true
      assert category.name == "some name"
      assert category.slug == "some slug"
      assert category.thumbnail == "some thumbnail"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()

      update_attrs = %{
        is_enabled: false,
        name: "some updated name",
        slug: "some updated slug",
        thumbnail: "some updated thumbnail"
      }

      assert {:ok, %Category{} = category} = Catalog.update_category(category, update_attrs)
      assert category.is_enabled == false
      assert category.name == "some updated name"
      assert category.slug == "some updated slug"
      assert category.thumbnail == "some updated thumbnail"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_category(category, @invalid_attrs)
      assert category == Catalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Catalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Catalog.change_category(category)
    end
  end

  describe "collections" do
    alias Nappy.Catalog.Collection

    import Nappy.CatalogFixtures

    @invalid_attrs %{}

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Catalog.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Catalog.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      valid_attrs = %{}

      assert {:ok, %Collection{} = collection} = Catalog.create_collection(valid_attrs)
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      update_attrs = %{}

      assert {:ok, %Collection{} = collection} =
               Catalog.update_collection(collection, update_attrs)
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_collection(collection, @invalid_attrs)
      assert collection == Catalog.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Catalog.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Catalog.change_collection(collection)
    end
  end

  describe "products" do
    alias Nappy.Catalog.Product

    import Nappy.CatalogFixtures

    @invalid_attrs %{description: nil, name: nil, sku: nil, unit_price: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        sku: 42,
        unit_price: 120.5
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.sku == 42
      assert product.unit_price == 120.5
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        sku: 43,
        unit_price: 456.7
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.sku == 43
      assert product.unit_price == 456.7
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
