defmodule NappyWeb.SeoControllerTest do
  use NappyWeb.ConnCase

  import Nappy.AdminFixtures

  @create_attrs %{
    default_categories_description: "some default_categories_description",
    default_collections_description: "some default_collections_description",
    default_description: "some default_description",
    default_keywords: "some default_keywords",
    global_banner_text: "some global_banner_text"
  }
  @update_attrs %{
    default_categories_description: "some updated default_categories_description",
    default_collections_description: "some updated default_collections_description",
    default_description: "some updated default_description",
    default_keywords: "some updated default_keywords",
    global_banner_text: "some updated global_banner_text"
  }
  @invalid_attrs %{
    default_categories_description: nil,
    default_collections_description: nil,
    default_description: nil,
    default_keywords: nil,
    global_banner_text: nil
  }

  describe "index" do
    test "lists all seo", %{conn: conn} do
      conn = get(conn, Routes.seo_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Seo"
    end
  end

  describe "new seo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.seo_path(conn, :new))
      assert html_response(conn, 200) =~ "New Seo"
    end
  end

  describe "create seo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.seo_path(conn, :create), seo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.seo_path(conn, :show, id)

      conn = get(conn, Routes.seo_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Seo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.seo_path(conn, :create), seo: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Seo"
    end
  end

  describe "edit seo" do
    setup [:create_seo]

    test "renders form for editing chosen seo", %{conn: conn, seo: seo} do
      conn = get(conn, Routes.seo_path(conn, :edit, seo))
      assert html_response(conn, 200) =~ "Edit Seo"
    end
  end

  describe "update seo" do
    setup [:create_seo]

    test "redirects when data is valid", %{conn: conn, seo: seo} do
      conn = put(conn, Routes.seo_path(conn, :update, seo), seo: @update_attrs)
      assert redirected_to(conn) == Routes.seo_path(conn, :show, seo)

      conn = get(conn, Routes.seo_path(conn, :show, seo))
      assert html_response(conn, 200) =~ "some updated default_categories_description"
    end

    test "renders errors when data is invalid", %{conn: conn, seo: seo} do
      conn = put(conn, Routes.seo_path(conn, :update, seo), seo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Seo"
    end
  end

  describe "delete seo" do
    setup [:create_seo]

    test "deletes chosen seo", %{conn: conn, seo: seo} do
      conn = delete(conn, Routes.seo_path(conn, :delete, seo))
      assert redirected_to(conn) == Routes.seo_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.seo_path(conn, :show, seo))
      end
    end
  end

  defp create_seo(_) do
    seo = seo_fixture()
    %{seo: seo}
  end
end
