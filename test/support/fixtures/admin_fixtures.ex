defmodule Nappy.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Admin` context.
  """

  @doc """
  Generate a settings.
  """
  def settings_fixture(attrs \\ %{}) do
    {:ok, settings} =
      attrs
      |> Enum.into(%{
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
      })
      |> Nappy.Admin.create_settings()

    settings
  end

  @doc """
  Generate a legal.
  """
  def legal_fixture(attrs \\ %{}) do
    {:ok, legal} =
      attrs
      |> Enum.into(%{
        privacy_link: "some privacy_link",
        terms_of_agreement_link: "some terms_of_agreement_link"
      })
      |> Nappy.Admin.create_legal()

    legal
  end

  @doc """
  Generate a seo.
  """
  def seo_fixture(attrs \\ %{}) do
    {:ok, seo} =
      attrs
      |> Enum.into(%{
        default_categories_description: "some default_categories_description",
        default_collections_description: "some default_collections_description",
        default_description: "some default_description",
        default_keywords: "some default_keywords",
        global_banner_text: "some global_banner_text"
      })
      |> Nappy.Admin.create_seo_detail()

    seo
  end
end
