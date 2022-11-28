defmodule NappyWeb.UserSettingsController do
  use NappyWeb, :controller

  alias Nappy.Accounts
  alias NappyWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html", page_title: "Profile settings")
  end

  def update(conn, %{"action" => "update_user"} = params) do
    %{"user" => %{"name" => name}, "username" => username} = params

    params = %{
      name: name,
      username: username
    }

    user = conn.assigns.current_user

    case Accounts.update_user(user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Updated successfully")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", user_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_social_media"} = params) do
    %{"social_media" => %{"contact_email" => contact_email}} = params

    params = %{
      bio: params["bio"],
      contact_email: contact_email,
      facebook_link: params["facebook_link"],
      instagram_link: params["instagram_link"],
      twitter_link: params["twitter_link"],
      website_link: params["website_link"]
    }

    user_id = conn.assigns.current_user.id

    case Accounts.update_social_media(user_id, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Updated successfully")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", social_media_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:user_changeset, Accounts.change_user(user))
    |> assign(:social_media_changeset, Accounts.change_social_media(user.id))
  end
end
