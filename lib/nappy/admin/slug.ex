defmodule Nappy.Admin.Slug do
  @moduledoc """
  Slug generator (for a lack of better term 🤷)

  Instead of exposing uuid or id of a resource (i.e. name,
  username, image id, etc.), we can mask this with random
  alphanumeric combinations. This may be useful outside
  of url paths or masking resource identifier.
  """

  @alphabet Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9)
  @length 12

  @doc """
  Generate random alphanumeric strings of a certain length.
  Default length of 12.

  ## Examples

      iex> random_alphanumeric()
      j1ea85Pp4s88

      iex> random_alphanumeric(4)
      y83r
  """
  def random_alphanumeric(length \\ @length) do
    # for _ <- 1..@length, into: "", do: << Enum.random(@alphabet) >>
    1..length
    |> Enum.map(fn _ -> Enum.random(@alphabet) end)
    |> to_string()
  end

  def slugify(words) do
    words
    |> String.downcase()
    |> String.replace(~r/[^a-zA-Z0-9\s&]/, "")
    |> String.replace("&", "and")
    |> String.split()
    |> Enum.join("-")
  end
end
