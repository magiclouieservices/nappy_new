defmodule NappyWeb.SettingsControllerTest do
  use NappyWeb.ConnCase

  import Nappy.AdminFixtures

  @create_attrs %{
    allow_downloads: true,
    allow_oauth_login: true,
    allow_registration: true,
    allow_uploads: true,
    enable_captcha: true,
    image_per_page: 42,
    maintenance_enabled: true,
    max_concurrent_upload: 42,
    max_image_upload_size: 42,
    max_tag_count: 42,
    min_height_upload_image: 42,
    min_width_upload_image: 42,
    notifier_email: "some notifier_email",
    support_email: "some support_email"
  }
  @update_attrs %{
    allow_downloads: false,
    allow_oauth_login: false,
    allow_registration: false,
    allow_uploads: false,
    enable_captcha: false,
    image_per_page: 43,
    maintenance_enabled: false,
    max_concurrent_upload: 43,
    max_image_upload_size: 43,
    max_tag_count: 43,
    min_height_upload_image: 43,
    min_width_upload_image: 43,
    notifier_email: "some updated notifier_email",
    support_email: "some updated support_email"
  }
  @invalid_attrs %{
    allow_downloads: nil,
    allow_oauth_login: nil,
    allow_registration: nil,
    allow_uploads: nil,
    enable_captcha: nil,
    image_per_page: nil,
    maintenance_enabled: nil,
    max_concurrent_upload: nil,
    max_image_upload_size: nil,
    max_tag_count: nil,
    min_height_upload_image: nil,
    min_width_upload_image: nil,
    notifier_email: nil,
    support_email: nil
  }

  describe "index" do
    test "lists all settings", %{conn: conn} do
      conn = get(conn, Routes.settings_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Settings"
    end
  end

  describe "new settings" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.settings_path(conn, :new))
      assert html_response(conn, 200) =~ "New Settings"
    end
  end

  describe "create settings" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.settings_path(conn, :create), settings: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.settings_path(conn, :show, id)

      conn = get(conn, Routes.settings_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Settings"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.settings_path(conn, :create), settings: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Settings"
    end
  end

  describe "edit settings" do
    setup [:create_settings]

    test "renders form for editing chosen settings", %{conn: conn, settings: settings} do
      conn = get(conn, Routes.settings_path(conn, :edit, settings))
      assert html_response(conn, 200) =~ "Edit Settings"
    end
  end

  describe "update settings" do
    setup [:create_settings]

    test "redirects when data is valid", %{conn: conn, settings: settings} do
      conn = put(conn, Routes.settings_path(conn, :update, settings), settings: @update_attrs)
      assert redirected_to(conn) == Routes.settings_path(conn, :show, settings)

      conn = get(conn, Routes.settings_path(conn, :show, settings))
      assert html_response(conn, 200) =~ "some updated notifier_email"
    end

    test "renders errors when data is invalid", %{conn: conn, settings: settings} do
      conn = put(conn, Routes.settings_path(conn, :update, settings), settings: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Settings"
    end
  end

  describe "delete settings" do
    setup [:create_settings]

    test "deletes chosen settings", %{conn: conn, settings: settings} do
      conn = delete(conn, Routes.settings_path(conn, :delete, settings))
      assert redirected_to(conn) == Routes.settings_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.settings_path(conn, :show, settings))
      end
    end
  end

  defp create_settings(_) do
    settings = settings_fixture()
    %{settings: settings}
  end
end
