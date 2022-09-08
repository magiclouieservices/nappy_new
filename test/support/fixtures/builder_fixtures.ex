defmodule Nappy.BuilderFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Builder` context.
  """

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        content: "some content",
        is_enabled: "some is_enabled",
        slug: "some slug",
        thumbnail: "some thumbnail",
        title: "some title"
      })
      |> Nappy.Builder.create_page()

    page
  end
end
