defmodule Nappy.UploadImagesBehaviour do
  @moduledoc false

  @callback single_upload(String.t(), String.t()) :: [map()]
  @callback bulk_upload(String.t(), String.t(), integer()) :: [map()]
end
