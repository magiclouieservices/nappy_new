defmodule NappyWeb.LiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  alias Nappy.Accounts
  alias Nappy.Metrics

  @moduledoc false

  def on_mount(:check_auth, _params, session, socket) do
    socket =
      case session do
        %{"user_token" => user_token} ->
          user = Accounts.get_user_by_session_token(user_token)
          Accounts.subscribe(user.id)
          pubsub_notif = Metrics.list_notifications_from_user(user.id)

          socket
          |> assign_new(:pubsub_notif, fn -> pubsub_notif end)
          |> assign_new(:current_user, fn -> user end)

        %{} ->
          socket
          |> assign_new(:pubsub_notif, fn -> [] end)
          |> assign_new(:current_user, fn -> nil end)
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
