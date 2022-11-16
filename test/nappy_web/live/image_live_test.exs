defmodule NappyWeb.ImageLiveTest do
  use ExUnit.Case, async: true
  use NappyWeb.ConnCase

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

    {:ok, true} =
      Nappy.cache_name()
      |> Cachex.put("test_slug-test_tag", payload, ttl: :timer.seconds(1_599))

    image_fixture()

    on_exit(fn ->
      {:ok, _count} = Cachex.clear(:nappy_cache)
    end)

    :ok
  end

  describe "live(/photo/:slug, ImageLive.Show, :show)" do
    test "success: visits an existing image page", %{conn: conn} do
      assert {:ok, index_live, _html} =
               live(conn, Routes.image_show_path(conn, :show, "some-title-test_slug"))

      # only 1 span[x-id] is using in a specific image page:
      # and it's "more-info" button
      assert index_live |> element("span[x-id]", "more info") |> has_element?()
    end

    test "success: redirect a slug to a full path", %{conn: conn} do
      assert {:error, {:live_redirect, %{flash: %{}, to: path}}} =
               live(conn, Routes.image_show_path(conn, :show, "test_slug"))

      assert {:ok, _, _} = live(conn, Routes.image_show_path(conn, :show, path))
    end

    test "error: visits a non-existing image page", %{conn: conn} do
      exception_name =
        try do
          live(conn, Routes.image_show_path(conn, :show, "non-existing-slug"))
        rescue
          e in NappyWeb.FallbackController -> e
        end

      assert %NappyWeb.FallbackController{message: "Not Found"} = exception_name
    end

    # test "error: visit a non-existing image page" do
    #   {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

    #   assert index_live |> element("a", "New Product") |> render_click() =~
    #            "New Product"

    #   assert_patch(index_live, Routes.product_index_path(conn, :new))

    #   assert index_live
    #          |> form("#product-form", product: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   {:ok, _, html} =
    #     index_live
    #     |> form("#product-form", product: @create_attrs)
    #     |> render_submit()
    #     |> follow_redirect(conn, Routes.product_index_path(conn, :index))

    #   assert html =~ "Product created successfully"
    #   assert html =~ "some description"
    # end
  end
end
