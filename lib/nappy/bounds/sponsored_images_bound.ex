defmodule Nappy.SponsoredImagesBound do
  @moduledoc false

  alias Nappy.SponsoredImages

  def get_images(key_name, tags) do
    impl().get_images(key_name, tags)
  end

  def get_images(key_name, tags, page_size) do
    impl().get_images(key_name, tags, page_size)
  end

  defp impl do
    Application.get_env(:nappy, :sponsored_images, SponsoredImages)
  end
end
