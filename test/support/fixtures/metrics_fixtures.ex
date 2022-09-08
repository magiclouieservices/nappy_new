defmodule Nappy.MetricsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Metrics` context.
  """

  @doc """
  Generate a image_metadata.
  """
  def image_metadata_fixture(attrs \\ %{}) do
    {:ok, image_metadata} =
      attrs
      |> Enum.into(%{
        aperture: 120.5,
        aspect_ratio: 120.5,
        camera_software: "some camera_software",
        device_model: "some device_model",
        extension_type: "some extension_type",
        file_size: 120.5,
        focal: 120.5,
        height: 42,
        iso: 42,
        shutter_speed: 120.5,
        width: 42
      })
      |> Nappy.Metrics.create_image_metadata()

    image_metadata
  end

  @doc """
  Generate a image_analytics.
  """
  def image_analytics_fixture(attrs \\ %{}) do
    {:ok, image_analytics} =
      attrs
      |> Enum.into(%{
        approved_date: ~N[2022-05-21 23:38:00],
        download_count: 42,
        featured_date: ~N[2022-05-21 23:38:00],
        like_count: 42,
        view_count: 42
      })
      |> Nappy.Metrics.create_image_analytics()

    image_analytics
  end

  @doc """
  Generate a liked_image.
  """
  def liked_image_fixture(attrs \\ %{}) do
    {:ok, liked_image} =
      attrs
      |> Enum.into(%{
        is_liked: true
      })
      |> Nappy.Metrics.create_liked_image()

    liked_image
  end
end
