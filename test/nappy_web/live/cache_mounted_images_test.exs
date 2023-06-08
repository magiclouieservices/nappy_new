defmodule NappyWeb.CacheMountedImagesTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

  alias Nappy.Catalog.Collection
  alias Nappy.CatalogFixtures

  import Ecto.Query, warn: false
  import Phoenix.LiveViewTest
  import Nappy.CatalogFixtures

  setup do
    payload =
      Enum.map(1..5, fn num ->
        %{
          "image_alt" => "Image number #{num}",
          "image_src" => "https://media.istockphoto.com/photos/photo-#{num}",
          "referral_link" => "https://istockphoto.com/referral/photo-#{num}"
        }
      end)

    ttl = :timer.seconds(1_599)

    {:ok, true} =
      Nappy.cache_name()
      |> Cachex.put("slug#{System.unique_integer()}", payload, ttl: ttl)

    on_exit(fn ->
      {:ok, _count} = Cachex.clear(Nappy.cache_name())
    end)

    [:featured, :active]
    |> Enum.each(fn image_status ->
      %{
        slug: "slug#{System.unique_integer()}",
        tags: "test_tag,testpic,test"
      }
      |> CatalogFixtures.image_fixture(image_status)
    end)

    Nappy.cache_name()
    |> Cachex.count()

    :ok
  end

  describe "cache image gallery:" do
    test "(success) featured images", %{conn: conn} do
      assert {:ok, _view, _html} = live(conn, Routes.home_index_path(conn, :index))
      assert {:ok, keys} = Nappy.cache_name() |> Cachex.keys()
      assert "homepage_featured" in keys === true
    end

    test "(success) popular images", %{conn: conn} do
      assert {:ok, _view, _html} =
               live(conn, Routes.home_index_path(conn, :index, filter: :popular))

      assert {:ok, keys} = Nappy.cache_name() |> Cachex.keys()
      assert "homepage_popular" in keys === true
    end

    test "(success) all images", %{conn: conn} do
      assert {:ok, _view, _html} = live(conn, Routes.home_index_path(conn, :index, filter: :all))

      assert {:ok, keys} = Nappy.cache_name() |> Cachex.keys()
      assert "homepage_all" in keys === true
    end

    test "(success) specific category", %{conn: conn} do
      slug = "other"

      assert {:ok, _view, _html} = live(conn, Routes.category_show_path(conn, :show, slug))
      assert {:ok, keys} = Nappy.cache_name() |> Cachex.keys()
      assert "category_other" in keys === true
    end

    test "(success) specific collection", %{conn: conn} do
      title = "Good Hair"
      slug = "good-hair"

      %{title: title, slug: slug}
      |> CatalogFixtures.collection_fixture()

      assert {:ok, _view, _html} = live(conn, Routes.collections_show_path(conn, :show, slug))
      assert {:ok, keys} = Nappy.cache_name() |> Cachex.keys()
      assert "collection_good-hair" in keys === true
    end
  end
end
