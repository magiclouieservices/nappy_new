defmodule NappyWeb.IncrementViewCountTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

  alias Nappy.CatalogFixtures

  import Phoenix.LiveViewTest

  setup do
    # gallery_component.ex#L64, adverts won't be
    # displayed when number of images < 7
    1..10
    |> Enum.each(
      &CatalogFixtures.image_fixture(%{slug: "slug_#{&1}", tags: "tag_#{&1}"}, :featured)
    )

    images = CatalogFixtures.paginate_images(:featured, page: 1, page_size: 10)

    pending_image = CatalogFixtures.image_fixture(%{slug: "pending_slug"}, :pending)

    sponsored =
      Enum.map(1..4, fn num ->
        %{
          "image_alt" => "Image number #{num}",
          "image_src" => "https://media.istockphoto.com/photos/photo-#{num}",
          "referral_link" => "https://istockphoto.com/referral/photo-#{num}"
        }
      end)

    index_pos = length(images.entries) - 1
    entries = List.insert_at(images.entries, index_pos, %{sponsored: sponsored})
    images = Map.put(images, :entries, entries)

    ttl = :timer.seconds(1_599)
    homepage_cache_key_name = "homepage_featured"

    image =
      images.entries
      |> Enum.filter(&(Map.get(&1, :slug) === "slug_1"))
      |> hd()

    {:ok, true} =
      Nappy.cache_name()
      |> Cachex.put(homepage_cache_key_name, images, ttl: ttl)

    Enum.each(1..10, fn n ->
      Nappy.cache_name()
      |> Cachex.put("image_adverts_1-tag_#{n}", sponsored, ttl: ttl)

      Nappy.cache_name()
      |> Cachex.put("slug_#{n}-tag_#{n}", sponsored, ttl: ttl)
    end)

    on_exit(fn ->
      {:ok, _count} = Cachex.clear(Nappy.cache_name())
    end)

    %{image: image, pending_image: pending_image}
  end

  describe "image view count" do
    test "success: increments once", %{conn: conn, image: image} do
      assert {:ok, view, _html} = live(conn, Routes.home_index_path(conn, :index))

      assert render_hook(view, :increment_view_count, %{slug: "slug_1"}) =~
               ~s(phx-hook="ViewCount")

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 1 === image_analytics.view_count
    end

    test "success: increments thrice", %{conn: conn, image: image} do
      assert {:ok, view, _html} = live(conn, Routes.home_index_path(conn, :index))

      Enum.each(1..3, fn _ ->
        assert render_hook(view, :increment_view_count, %{slug: "slug_1"}) =~
                 ~s(phx-hook="ViewCount")
      end)

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 3 === image_analytics.view_count
    end

    test "success: visits specific image and increments once", %{conn: conn, image: image} do
      assert {:ok, _view, _html} =
               live(conn, Routes.image_show_path(conn, :show, "some-title+slug_1"))

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 1 === image_analytics.view_count
    end

    test "success: redirects and increments once", %{conn: conn, image: image} do
      assert {:error, {:live_redirect, %{flash: %{}, to: path}}} =
               live(conn, Routes.image_show_path(conn, :show, "slug_1"))

      assert {:ok, _, _} = live(conn, Routes.image_show_path(conn, :show, URI.decode(path)))

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 1 === image_analytics.view_count
    end

    test "success: pending image will never increment", %{
      conn: conn,
      pending_image: pending_image
    } do
      exception_name =
        try do
          live(conn, Routes.image_show_path(conn, :show, "non-existing-slug"))
        rescue
          e in NappyWeb.FallbackController -> e
        end

      assert %NappyWeb.FallbackController{message: "Not Found"} = exception_name

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(pending_image.slug)
      assert 0 === image_analytics.view_count
    end
  end
end
