defmodule NappyWeb.HomeController do
  use NappyWeb, :controller

  action_fallback NappyWeb.FallbackController

  def fallback(_conn, _), do: {:error, :not_found}
end
