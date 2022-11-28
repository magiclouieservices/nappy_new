defmodule NappyWeb.UserRegistrationController do
  use NappyWeb, :controller

  alias Nappy.Accounts
  alias Nappy.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset, page_title: "Sign up")
  end

  def create(conn, %{"user" => user_params}) do
    result =
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &Routes.user_confirmation_url(conn, :edit, &1)
            )

          conn
          |> put_flash(:info, "Check your email for confirmation link")
          |> redirect(to: "/login")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end

    result
  end
end
