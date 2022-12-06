defmodule NappyWeb.IncrementViewCountTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

  alias Nappy.CatalogFixtures

  import Phoenix.LiveViewTest

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
    cache_key_name = "test_slug-test_tag"

    {:ok, true} =
      Nappy.cache_name()
      |> Cachex.put(cache_key_name, payload, ttl: ttl)

    on_exit(fn ->
      {:ok, _count} = Cachex.clear(Nappy.cache_name())
    end)

    image = CatalogFixtures.image_fixture(%{}, :featured)
    pending_image = CatalogFixtures.image_fixture(%{slug: "pending_slug"}, :pending)

    %{image: image, pending_image: pending_image}
  end

  describe "image view count" do
    test "success: increments once", %{conn: conn, image: image} do
      assert {:ok, view, html} = live(conn, Routes.home_index_path(conn, :index))

      assert render_hook(view, :increment_view_count, %{slug: "test_slug"}) =~
               ~s(phx-hook="ViewCount")

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 1 === image_analytics.view_count
    end

    test "success: increments thrice", %{conn: conn, image: image} do
      assert {:ok, view, html} = live(conn, Routes.home_index_path(conn, :index))

      Enum.each(1..3, fn _ ->
        assert render_hook(view, :increment_view_count, %{slug: "test_slug"}) =~
                 ~s(phx-hook="ViewCount")
      end)

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 3 === image_analytics.view_count
    end

    test "success: visits specific image and increments once", %{conn: conn, image: image} do
      assert {:ok, view, _html} =
               live(conn, Routes.image_show_path(conn, :show, "some-title-test_slug"))

      image_analytics = Nappy.Metrics.get_image_analytics_by_slug(image.slug)
      assert 1 === image_analytics.view_count
    end

    test "success: redirects and increments once", %{conn: conn, image: image} do
      assert {:error, {:live_redirect, %{flash: %{}, to: path}}} =
               live(conn, Routes.image_show_path(conn, :show, "test_slug"))

      assert {:ok, _, _} = live(conn, Routes.image_show_path(conn, :show, path))

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
