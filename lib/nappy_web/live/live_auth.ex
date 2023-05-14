defmodule NappyWeb.LiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  alias Nappy.Accounts

  @moduledoc false

  def on_mount(:check_auth, _params, session, socket) do
    socket =
      case session do
        %{"user_token" => user_token} ->
          socket
          |> assign_new(:notif_count, fn -> 0 end)
          |> assign_new(:current_user, fn ->
            user = Accounts.get_user_by_session_token(user_token)
            Accounts.subscribe(user.id)
            user
          end)

        %{} ->
          assign_new(socket, :current_user, fn -> nil end)
      end

    {:cont, socket}
  end

  def on_mount(:user, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
