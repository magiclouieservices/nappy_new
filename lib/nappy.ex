defmodule Nappy do
  @moduledoc """
  Nappy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def app_name do
    Application.get_env(:nappy, :config)[:app_name]
  end
end
