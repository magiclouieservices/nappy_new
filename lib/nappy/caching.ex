defmodule Nappy.Caching do
  @moduledoc """
  Helper function for adding cache.
  """

  @doc """
  Adding cache with default expiration of 30 days.

  ## Examples
      iex> get_or_add_payload("hello", "world")
      "world"

  """
  @spec get_or_add_payload(String.t(), any(), integer()) :: any()
  def get_or_add_payload(payload_name, payload, ttl \\ 720) do
    cache = Nappy.cache_name() |> Cachex.get(payload_name)

    case cache do
      {:ok, nil} ->
        # 30 days
        ttl = :timer.hours(ttl)

        {:ok, _} =
          Nappy.cache_name()
          |> Cachex.put("#{payload_name}", payload, ttl: ttl)

        payload

      {:ok, payload} ->
        payload
    end
  end
end
