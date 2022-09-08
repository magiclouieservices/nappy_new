defmodule NappyWeb.UserProfileController do
  use NappyWeb, :controller
  alias Nappy.Accounts

  action_fallback NappyWeb.FallbackController

  def show(conn, %{"username" => username} = _params) do
    user = Accounts.get_user_by_username(username)

    if user,
      do: render(conn, "show.html", user: user),
      else: {:error, :not_found}
  end
end
