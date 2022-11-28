defmodule NappyWeb.LiveTitleFromPopupImageTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias Nappy.CatalogFixtures
  alias Wallaby.Query

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

    image = Nappy.CatalogFixtures.image_fixture(%{}, :featured)

    %{
      default_prefix: Nappy.app_name(),
      title: image.title,
      suffix_title: " | Beautifully Diverse Stock Photos"
    }
  end

  feature "change to image title when popup appears", %{
    title: title,
    session: session,
    suffix_title: suffix_title
  } do
    page_title = title <> suffix_title

    session
    |> visit("/")
    |> assert_has(Query.css("a[phx-click=show_images]"))
    |> click(Query.css("a[phx-click=show_images]"))

    assert page_title(session) === page_title
  end

  feature "change to default title when close button is clicked", %{
    session: session,
    default_prefix: default_prefix,
    suffix_title: suffix_title
  } do
    page_title = default_prefix <> suffix_title

    session
    |> visit("/")
    |> click(Query.css("a[phx-click=show_images]"))
    |> assert_has(Query.css("a[phx-click=show_images]"))
    |> click(Query.css(".close-popup-button"))

    assert page_title(session) === page_title
  end

  # feature "success: default title when escape key is pressed", %{session: session} do
  #   page_title = context.default_prefix <> context.suffix_title

  #   session
  #   |> visit("/")
  #   |> click(Query.css("a[phx-click=show_images]"))
  #   |> send_keys("escape")

  #   assert page_title(session) === page_title
  # end

  # feature "success: default title when clicked outside", %{
  #   session: session,
  #   suffix_title: suffix_title
  # } do
  #   page_title = "hi" <> suffix_title

  #   session
  #   |> visit("/")
  #   |> maximize_window()
  #   |> assert_has(Query.css("a[phx-click=show_images]"))
  #   |> click(Query.css("a[phx-click=show_images]"))
  #   |> move_mouse_by(0, 700)
  #   |> click(:left)

  #   assert page_title(session) === page_title
  # end
end
