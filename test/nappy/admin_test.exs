defmodule Nappy.AdminTest do
  use Nappy.DataCase

  alias Nappy.Admin

  describe "settings" do
    alias Nappy.Admin.Settings

    import Nappy.AdminFixtures

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

    test "list_settings/0 returns all settings" do
      settings = settings_fixture()
      assert Admin.list_settings() == [settings]
    end

    test "get_settings!/1 returns the settings with given id" do
      settings = settings_fixture()
      assert Admin.get_settings!(settings.id) == settings
    end

    test "create_settings/1 with valid data creates a settings" do
      valid_attrs = %{
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

      assert {:ok, %Settings{} = settings} = Admin.create_settings(valid_attrs)
      assert settings.allow_downloads == true
      assert settings.allow_oauth_login == true
      assert settings.allow_registration == true
      assert settings.allow_uploads == true
      assert settings.enable_captcha == true
      assert settings.image_per_page == 42
      assert settings.maintenance_enabled == true
      assert settings.max_concurrent_upload == 42
      assert settings.max_image_upload_size == 42
      assert settings.max_tag_count == 42
      assert settings.min_height_upload_image == 42
      assert settings.min_width_upload_image == 42
      assert settings.notifier_email == "some notifier_email"
      assert settings.support_email == "some support_email"
    end

    test "create_settings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_settings(@invalid_attrs)
    end

    test "update_settings/2 with valid data updates the settings" do
      settings = settings_fixture()

      update_attrs = %{
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

      assert {:ok, %Settings{} = settings} = Admin.update_settings(settings, update_attrs)
      assert settings.allow_downloads == false
      assert settings.allow_oauth_login == false
      assert settings.allow_registration == false
      assert settings.allow_uploads == false
      assert settings.enable_captcha == false
      assert settings.image_per_page == 43
      assert settings.maintenance_enabled == false
      assert settings.max_concurrent_upload == 43
      assert settings.max_image_upload_size == 43
      assert settings.max_tag_count == 43
      assert settings.min_height_upload_image == 43
      assert settings.min_width_upload_image == 43
      assert settings.notifier_email == "some updated notifier_email"
      assert settings.support_email == "some updated support_email"
    end

    test "update_settings/2 with invalid data returns error changeset" do
      settings = settings_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_settings(settings, @invalid_attrs)
      assert settings == Admin.get_settings!(settings.id)
    end

    test "delete_settings/1 deletes the settings" do
      settings = settings_fixture()
      assert {:ok, %Settings{}} = Admin.delete_settings(settings)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_settings!(settings.id) end
    end

    test "change_settings/1 returns a settings changeset" do
      settings = settings_fixture()
      assert %Ecto.Changeset{} = Admin.change_settings(settings)
    end
  end

  describe "legal" do
    alias Nappy.Admin.Legal

    import Nappy.AdminFixtures

    @invalid_attrs %{privacy_link: nil, terms_of_agreement_link: nil}

    test "list_legal/0 returns all legal" do
      legal = legal_fixture()
      assert Admin.list_legal() == [legal]
    end

    test "get_legal!/1 returns the legal with given id" do
      legal = legal_fixture()
      assert Admin.get_legal!(legal.id) == legal
    end

    test "create_legal/1 with valid data creates a legal" do
      valid_attrs = %{
        privacy_link: "some privacy_link",
        terms_of_agreement_link: "some terms_of_agreement_link"
      }

      assert {:ok, %Legal{} = legal} = Admin.create_legal(valid_attrs)
      assert legal.privacy_link == "some privacy_link"
      assert legal.terms_of_agreement_link == "some terms_of_agreement_link"
    end

    test "create_legal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_legal(@invalid_attrs)
    end

    test "update_legal/2 with valid data updates the legal" do
      legal = legal_fixture()

      update_attrs = %{
        privacy_link: "some updated privacy_link",
        terms_of_agreement_link: "some updated terms_of_agreement_link"
      }

      assert {:ok, %Legal{} = legal} = Admin.update_legal(legal, update_attrs)
      assert legal.privacy_link == "some updated privacy_link"
      assert legal.terms_of_agreement_link == "some updated terms_of_agreement_link"
    end

    test "update_legal/2 with invalid data returns error changeset" do
      legal = legal_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_legal(legal, @invalid_attrs)
      assert legal == Admin.get_legal!(legal.id)
    end

    test "delete_legal/1 deletes the legal" do
      legal = legal_fixture()
      assert {:ok, %Legal{}} = Admin.delete_legal(legal)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_legal!(legal.id) end
    end

    test "change_legal/1 returns a legal changeset" do
      legal = legal_fixture()
      assert %Ecto.Changeset{} = Admin.change_legal(legal)
    end
  end

  describe "seo" do
    alias Nappy.Admin.SeoDetail

    import Nappy.AdminFixtures

    @invalid_attrs %{
      default_categories_description: nil,
      default_collections_description: nil,
      default_description: nil,
      default_keywords: nil,
      global_banner_text: nil
    }

    test "list_seo_details/0 returns all seo" do
      seo = seo_fixture()
      assert Admin.list_seo_details() == [seo]
    end

    test "get_seo_detail!/1 returns the seo with given id" do
      seo = seo_fixture()
      assert Admin.get_seo_detail!(seo.id) == seo
    end

    test "create_seo_detail/1 with valid data creates a seo" do
      valid_attrs = %{
        default_categories_description: "some default_categories_description",
        default_collections_description: "some default_collections_description",
        default_description: "some default_description",
        default_keywords: "some default_keywords",
        global_banner_text: "some global_banner_text"
      }

      assert {:ok, %SeoDetail{} = seo} = Admin.create_seo_detail(valid_attrs)
      assert seo.default_categories_description == "some default_categories_description"
      assert seo.default_collections_description == "some default_collections_description"
      assert seo.default_description == "some default_description"
      assert seo.default_keywords == "some default_keywords"
      assert seo.global_banner_text == "some global_banner_text"
    end

    test "create_seo_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_seo_detail(@invalid_attrs)
    end

    test "update_seo_detail/2 with valid data updates the seo" do
      seo = seo_fixture()

      update_attrs = %{
        default_categories_description: "some updated default_categories_description",
        default_collections_description: "some updated default_collections_description",
        default_description: "some updated default_description",
        default_keywords: "some updated default_keywords",
        global_banner_text: "some updated global_banner_text"
      }

      assert {:ok, %SeoDetail{} = seo} = Admin.update_seo_detail(seo, update_attrs)
      assert seo.default_categories_description == "some updated default_categories_description"
      assert seo.default_collections_description == "some updated default_collections_description"
      assert seo.default_description == "some updated default_description"
      assert seo.default_keywords == "some updated default_keywords"
      assert seo.global_banner_text == "some updated global_banner_text"
    end

    test "update_seo_detail/2 with invalid data returns error changeset" do
      seo = seo_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_seo_detail(seo, @invalid_attrs)
      assert seo == Admin.get_seo_detail!(seo.id)
    end

    test "delete_seo_detail/1 deletes the seo" do
      seo = seo_fixture()
      assert {:ok, %SeoDetail{}} = Admin.delete_seo_detail(seo)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_seo_detail!(seo.id) end
    end

    test "change_seo/1 returns a seo changeset" do
      seo = seo_fixture()
      assert %Ecto.Changeset{} = Admin.change_seo(seo)
    end
  end
end
