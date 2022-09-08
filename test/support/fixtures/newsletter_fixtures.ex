defmodule Nappy.NewsletterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Newsletter` context.
  """

  @doc """
  Generate a subscriber.
  """
  def subscriber_fixture(attrs \\ %{}) do
    {:ok, subscriber} =
      attrs
      |> Enum.into(%{
        is_photographer: true
      })
      |> Nappy.Newsletter.create_subscriber()

    subscriber
  end

  @doc """
  Generate a referrer.
  """
  def referrer_fixture(attrs \\ %{}) do
    {:ok, referrer} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Nappy.Newsletter.create_referrer()

    referrer
  end
end
