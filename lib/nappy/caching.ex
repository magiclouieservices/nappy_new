defmodule Nappy.Caching do
  @moduledoc """
  Helper function for adding cache.
  """

  @doc """
  Adding cache with default expiration of 30 days. `ttl`
  option is counted by hours.

  ## Examples
      iex> get_or_add_payload("hello", "world")
      "world"

      iex> get_or_add_payload("foo", "bar", 3)
      "world"

  """
  @spec get_or_add_payload(payload_name :: String.t(), payload :: any(), ttl :: non_neg_integer()) ::
          any()
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

  @spec paginated_images_payload(
          mfa :: {module(), atom(), list(any())},
          payload_name :: String.t(),
          ttl :: non_neg_integer()
        ) :: any()
  def paginated_images_payload(mfa, payload_name, ttl) do
    {mod, fun, args} = mfa

    case Cachex.get(Nappy.cache_name(), payload_name) do
      {:ok, nil} ->
        payload = apply(mod, fun, args)

        {:ok, _} =
          Nappy.cache_name()
          |> Cachex.put("#{payload_name}", payload, ttl: ttl)

        payload

      {:ok, payload} ->
        payload
    end
  end
end
