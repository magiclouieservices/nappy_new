defmodule Nappy.CustomEctoTypes.Tags do
  use Ecto.Type

  @moduledoc false

  def type, do: :string

  def cast(tags), do: {:ok, tags}
  def dump(tags), do: {:ok, tags}

  def load(tags) when is_binary(tags) do
    {:ok, String.split(tags, ",", trim: true)}
  end

  def load(_), do: :error
end
