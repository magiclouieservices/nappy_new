defmodule Nappy.AccountsFixtures do
  alias Nappy.Repo

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nappy.Accounts` context.
  """

  def username, do: "username"
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Helloworld!123"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      "username" => username(),
      "email" => unique_user_email(),
      "password" => valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Nappy.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
