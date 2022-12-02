defmodule NappyWeb.ImageLiveTest do
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

    CatalogFixtures.image_fixture(%{}, :featured)

    :ok
  end

  describe "live(/photo/:slug, ImageLive.Show, :show)" do
    test "success: visits an existing image page", %{conn: conn} do
      assert {:ok, index_live, _html} =
               live(conn, Routes.image_show_path(conn, :show, "some-title-test_slug"))

      # only 1 span[x-id] is using in a specific image page:
      # and it's "more-info" button
      assert index_live |> element("span[x-id]", "More info") |> has_element?()
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
  end
end
