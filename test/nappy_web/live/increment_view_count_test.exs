defmodule NappyWeb.IncrementViewCountTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

  alias Nappy.CatalogFixtures

  import Phoenix.LiveViewTest

  setup do
    image = CatalogFixtures.image_fixture(%{}, :featured)

    %{image: image}
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
  end
end
