defmodule NappyWeb.Api.SponsoredImagesTest do
  use ExUnit.Case

  import Mox

  alias Nappy.SponsoredImages
  alias Nappy.SponsoredImagesBound

  setup :set_mox_global
  setup :verify_on_exit!

  setup_all do
    num = Enum.random(1..100)

    %{
      "image_alt" => "Image number #{num}",
      "image_src" => "https://media.istockphoto.com/photos/photo-#{num}",
      "referral_link" => "https://istockphoto.com/referral/photo-#{num}"
    }
  end

  describe "get_images/2 and get_images/3" do
    test "success: fetches default number of sponsored images", context do
      expect(SponsoredImagesBehaviourMock, :get_images, 1, fn key_name, tags ->
        assert key_name == "slug1234"
        assert tags == "white,umbrella,car"

        default_num_of_results = 5
        Enum.map(1..default_num_of_results, fn _ -> context end)
      end)

      sponsored_images = SponsoredImagesBound.get_images("slug1234", "white,umbrella,car")

      assert [
               %{
                 "image_alt" => _,
                 "image_src" => _,
                 "referral_link" => _
               }
               | _rest
             ] = sponsored_images

      assert length(sponsored_images) === 5
    end

    test "success: fetches 10 sponsored images", context do
      expect(SponsoredImagesBehaviourMock, :get_images, 1, fn key_name, tags, num_of_results ->
        assert key_name == "fetch1234"
        assert tags == "ice cream, puppy"
        assert num_of_results == 10

        Enum.map(1..num_of_results, fn _ -> context end)
      end)

      sponsored_images = SponsoredImagesBound.get_images("fetch1234", "ice cream, puppy", 10)

      assert [
               %{
                 "image_alt" => _,
                 "image_src" => _,
                 "referral_link" => _
               }
               | _rest
             ] = sponsored_images

      assert length(sponsored_images) === 10
    end

    test "success: using the real API" do
      Mox.stub_with(SponsoredImagesBehaviourMock, SponsoredImages)
    end
  end
end
