defmodule NappyWeb.UserSessionController do
  use NappyWeb, :controller

  alias Nappy.Accounts
  alias NappyWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email_or_username" => email_or_username, "password" => password} = user_params
    user = Accounts.get_user_by_email_or_username_and_password(email_or_username, password)

    if user do
      status_name = Accounts.get_account_status_name(user.account_status_id)

      case status_name do
        :pending ->
          conn
          |> put_flash(:info, "Please check your email for confirmation link")
          |> redirect(to: "/login")
          |> halt()

        :active ->
          UserAuth.log_in_user(conn, user, user_params)

        :banned ->
          conn
          |> put_flash(:info, "Your account's been banned. Reach out to support@nappy.co")
          |> redirect(to: "/")
          |> halt()
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
