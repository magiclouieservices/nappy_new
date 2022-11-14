defmodule Nappy.SponsoredImagesBehaviour do
  @moduledoc false

  @callback get_images(String.t(), String.t()) :: [map()]
  @callback get_images(String.t(), String.t(), integer()) :: [map()]
  @callback get_access_key(String.t()) :: String.t()
end
