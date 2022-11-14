defmodule NappyWeb.Api.UploadImagesTest do
  use ExUnit.Case

  import Mox

  alias Ecto.Adapters.SQL.Sandbox
  alias ExAws.S3
  alias Nappy.Accounts.User
  alias Nappy.Catalog
  alias Nappy.Metrics
  alias Nappy.Repo
  import Nappy.AccountsFixtures

  setup :set_mox_global
  setup :verify_on_exit!

  setup_all do
    bucket_name = "test-bucket"

    bucket_name
    |> S3.put_bucket("us-east-1")
    |> ExAws.request()

    on_exit(fn ->
      stream =
        bucket_name
        |> S3.list_objects()
        |> ExAws.stream!()
        |> Stream.map(& &1.key)

      {:ok, _} =
        bucket_name
        |> S3.delete_all_objects(stream)
        |> ExAws.request()

      {:ok, _} =
        bucket_name
        |> S3.delete_bucket()
        |> ExAws.request()
    end)

    params = %{
      category: "Other",
      file: %Plug.Upload{
        path: File.cwd!() |> Path.join("priv/static/images/image.jpg"),
        content_type: "image/jpeg",
        filename: "image.jpg"
      },
      tags: "test,testpic",
      title: "test image"
    }

    %{
      non_bucket: "non-existing-bucket",
      bucket: bucket_name,
      params: params
    }
  end

  setup do
    # Explicitly get a connection on start
    :ok = Sandbox.checkout(Nappy.Repo)
  end

  test "error: can't find object(s) from non-existing bucket", context do
    assert {:error, {:http_error, 404, %{status_code: 404}}} =
             context.non_bucket
             |> S3.list_objects()
             |> ExAws.request()
  end

  test "error: removing non-existing bucket", context do
    assert {:error, {:http_error, 404, %{status_code: 404}}} =
             context.non_bucket
             |> S3.delete_bucket()
             |> ExAws.request()
  end

  describe "Catalog.single_upload/1" do
    test "success: uploads an image to existing bucket", context do
      user = user_fixture()

      params = Map.put(context.params, :user_id, user.id)

      assert match?(%User{}, user)
      assert [_slug] = Catalog.single_upload(context.bucket, params)
    end
  end

  describe "Catalog.delete_image/1" do
    test "success: deletes image from db, object storage, metadata and analytics", context do
      user = user_fixture()

      params = Map.put(context.params, :user_id, user.id)
      [slug] = Catalog.single_upload(context.bucket, params)
      image = Catalog.get_image_by_slug(slug)
      ext = Metrics.get_image_extension(image.id)
      file_path = "photos/#{slug}.#{ext}"

      assert match?(%User{}, user)

      assert {:ok, %{status_code: 204}} = Catalog.delete_image(image, context.bucket)

      {:ok,
       %{
         body: %{contents: contents},
         status_code: 200
       }} = S3.list_objects(context.bucket) |> ExAws.request()

      assert false === Enum.any?(contents, &(&1.key === file_path))
      assert nil === Catalog.get_image_by_slug(slug)
      assert nil === Repo.get_by(Metrics.ImageMetadata, image_id: image.id)
      assert nil === Repo.get_by(Metrics.ImageAnalytics, image_id: image.id)
    end
  end
end
