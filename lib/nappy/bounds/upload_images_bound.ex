defmodule Nappy.UploadImagesBound do
  @moduledoc false

  alias Nappy.Catalog

  def single_upload(key_name, tags) do
    impl().single_upload(key_name, tags)
  end

  def bulk_upload(key_name, tags, page_size) do
    impl().bulk_upload(key_name, tags, page_size)
  end

  defp impl do
    Application.get_env(:nappy, :upload_images, Catalog)
  end
end
