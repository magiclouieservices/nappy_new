defmodule NappyWeb.LiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  alias Nappy.Accounts

  @moduledoc false

  def on_mount(:check_auth, _params, session, socket) do
    socket =
      case session do
        %{"user_token" => user_token} ->
          assign_new(socket, :current_user, fn ->
            Accounts.get_user_by_session_token(user_token)
          end)

        %{} ->
          assign_new(socket, :current_user, fn -> nil end)
      end

    {:cont, socket}
  end
end
