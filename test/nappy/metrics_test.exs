defmodule Nappy.MetricsTest do
  use Nappy.DataCase

  alias Nappy.Metrics

  describe "image_metadata" do
    alias Nappy.Metrics.ImageMetadata

    import Nappy.MetricsFixtures

    @invalid_attrs %{
      aperture: nil,
      aspect_ratio: nil,
      camera_software: nil,
      device_model: nil,
      extension_type: nil,
      file_size: nil,
      focal: nil,
      height: nil,
      iso: nil,
      shutter_speed: nil,
      width: nil
    }

    test "list_image_metadata/0 returns all image_metadata" do
      image_metadata = image_metadata_fixture()
      assert Metrics.list_image_metadata() == [image_metadata]
    end

    test "get_image_metadata!/1 returns the image_metadata with given id" do
      image_metadata = image_metadata_fixture()
      assert Metrics.get_image_metadata!(image_metadata.id) == image_metadata
    end

    test "create_image_metadata/1 with valid data creates a image_metadata" do
      valid_attrs = %{
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
      }

      assert {:ok, %ImageMetadata{} = image_metadata} = Metrics.create_image_metadata(valid_attrs)
      assert image_metadata.aperture == 120.5
      assert image_metadata.aspect_ratio == 120.5
      assert image_metadata.camera_software == "some camera_software"
      assert image_metadata.device_model == "some device_model"
      assert image_metadata.extension_type == "some extension_type"
      assert image_metadata.file_size == 120.5
      assert image_metadata.focal == 120.5
      assert image_metadata.height == 42
      assert image_metadata.iso == 42
      assert image_metadata.shutter_speed == 120.5
      assert image_metadata.width == 42
    end

    test "create_image_metadata/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrics.create_image_metadata(@invalid_attrs)
    end

    test "update_image_metadata/2 with valid data updates the image_metadata" do
      image_metadata = image_metadata_fixture()

      update_attrs = %{
        aperture: 456.7,
        aspect_ratio: 456.7,
        camera_software: "some updated camera_software",
        device_model: "some updated device_model",
        extension_type: "some updated extension_type",
        file_size: 456.7,
        focal: 456.7,
        height: 43,
        iso: 43,
        shutter_speed: 456.7,
        width: 43
      }

      assert {:ok, %ImageMetadata{} = image_metadata} =
               Metrics.update_image_metadata(image_metadata, update_attrs)

      assert image_metadata.aperture == 456.7
      assert image_metadata.aspect_ratio == 456.7
      assert image_metadata.camera_software == "some updated camera_software"
      assert image_metadata.device_model == "some updated device_model"
      assert image_metadata.extension_type == "some updated extension_type"
      assert image_metadata.file_size == 456.7
      assert image_metadata.focal == 456.7
      assert image_metadata.height == 43
      assert image_metadata.iso == 43
      assert image_metadata.shutter_speed == 456.7
      assert image_metadata.width == 43
    end

    test "update_image_metadata/2 with invalid data returns error changeset" do
      image_metadata = image_metadata_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Metrics.update_image_metadata(image_metadata, @invalid_attrs)

      assert image_metadata == Metrics.get_image_metadata!(image_metadata.id)
    end

    test "delete_image_metadata/1 deletes the image_metadata" do
      image_metadata = image_metadata_fixture()
      assert {:ok, %ImageMetadata{}} = Metrics.delete_image_metadata(image_metadata)
      assert_raise Ecto.NoResultsError, fn -> Metrics.get_image_metadata!(image_metadata.id) end
    end

    test "change_image_metadata/1 returns a image_metadata changeset" do
      image_metadata = image_metadata_fixture()
      assert %Ecto.Changeset{} = Metrics.change_image_metadata(image_metadata)
    end
  end

  describe "image_analytics" do
    alias Nappy.Metrics.ImageAnalytics

    import Nappy.MetricsFixtures

    @invalid_attrs %{
      approved_date: nil,
      download_count: nil,
      featured_date: nil,
      like_count: nil,
      view_count: nil
    }

    test "list_image_analytics/0 returns all image_analytics" do
      image_analytics = image_analytics_fixture()
      assert Metrics.list_image_analytics() == [image_analytics]
    end

    test "get_image_analytics!/1 returns the image_analytics with given id" do
      image_analytics = image_analytics_fixture()
      assert Metrics.get_image_analytics!(image_analytics.id) == image_analytics
    end

    test "create_image_analytics/1 with valid data creates a image_analytics" do
      valid_attrs = %{
        approved_date: ~N[2022-05-21 23:38:00],
        download_count: 42,
        featured_date: ~N[2022-05-21 23:38:00],
        like_count: 42,
        view_count: 42
      }

      assert {:ok, %ImageAnalytics{} = image_analytics} =
               Metrics.create_image_analytics(valid_attrs)

      assert image_analytics.approved_date == ~N[2022-05-21 23:38:00]
      assert image_analytics.download_count == 42
      assert image_analytics.featured_date == ~N[2022-05-21 23:38:00]
      assert image_analytics.like_count == 42
      assert image_analytics.view_count == 42
    end

    test "create_image_analytics/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrics.create_image_analytics(@invalid_attrs)
    end

    test "update_image_analytics/2 with valid data updates the image_analytics" do
      image_analytics = image_analytics_fixture()

      update_attrs = %{
        approved_date: ~N[2022-05-22 23:38:00],
        download_count: 43,
        featured_date: ~N[2022-05-22 23:38:00],
        like_count: 43,
        view_count: 43
      }

      assert {:ok, %ImageAnalytics{} = image_analytics} =
               Metrics.update_image_analytics(image_analytics, update_attrs)

      assert image_analytics.approved_date == ~N[2022-05-22 23:38:00]
      assert image_analytics.download_count == 43
      assert image_analytics.featured_date == ~N[2022-05-22 23:38:00]
      assert image_analytics.like_count == 43
      assert image_analytics.view_count == 43
    end

    test "update_image_analytics/2 with invalid data returns error changeset" do
      image_analytics = image_analytics_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Metrics.update_image_analytics(image_analytics, @invalid_attrs)

      assert image_analytics == Metrics.get_image_analytics!(image_analytics.id)
    end

    test "delete_image_analytics/1 deletes the image_analytics" do
      image_analytics = image_analytics_fixture()
      assert {:ok, %ImageAnalytics{}} = Metrics.delete_image_analytics(image_analytics)
      assert_raise Ecto.NoResultsError, fn -> Metrics.get_image_analytics!(image_analytics.id) end
    end

    test "change_image_analytics/1 returns a image_analytics changeset" do
      image_analytics = image_analytics_fixture()
      assert %Ecto.Changeset{} = Metrics.change_image_analytics(image_analytics)
    end
  end

  describe "liked_images" do
    alias Nappy.Metrics.LikedImage

    import Nappy.MetricsFixtures

    @invalid_attrs %{is_liked: nil}

    test "list_liked_images/0 returns all liked_images" do
      liked_image = liked_image_fixture()
      assert Metrics.list_liked_images() == [liked_image]
    end

    test "get_liked_image!/1 returns the liked_image with given id" do
      liked_image = liked_image_fixture()
      assert Metrics.get_liked_image!(liked_image.id) == liked_image
    end

    test "create_liked_image/1 with valid data creates a liked_image" do
      valid_attrs = %{is_liked: true}

      assert {:ok, %LikedImage{} = liked_image} = Metrics.create_liked_image(valid_attrs)
      assert liked_image.is_liked == true
    end

    test "create_liked_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrics.create_liked_image(@invalid_attrs)
    end

    test "update_liked_image/2 with valid data updates the liked_image" do
      liked_image = liked_image_fixture()
      update_attrs = %{is_liked: false}

      assert {:ok, %LikedImage{} = liked_image} =
               Metrics.update_liked_image(liked_image, update_attrs)

      assert liked_image.is_liked == false
    end

    test "update_liked_image/2 with invalid data returns error changeset" do
      liked_image = liked_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Metrics.update_liked_image(liked_image, @invalid_attrs)
      assert liked_image == Metrics.get_liked_image!(liked_image.id)
    end

    test "delete_liked_image/1 deletes the liked_image" do
      liked_image = liked_image_fixture()
      assert {:ok, %LikedImage{}} = Metrics.delete_liked_image(liked_image)
      assert_raise Ecto.NoResultsError, fn -> Metrics.get_liked_image!(liked_image.id) end
    end

    test "change_liked_image/1 returns a liked_image changeset" do
      liked_image = liked_image_fixture()
      assert %Ecto.Changeset{} = Metrics.change_liked_image(liked_image)
    end
  end
end
