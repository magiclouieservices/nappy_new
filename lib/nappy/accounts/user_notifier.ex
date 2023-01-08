defmodule Nappy.Accounts.UserNotifier do
  import Swoosh.Email

  alias Nappy.Mailer

  @moduledoc """
  Mail notification for users.
  """

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({Nappy.app_name(), Nappy.notifications_email()})
      |> subject(subject)
      |> html_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp compose_html_body(template, assigns) do
    NappyWeb.EmailView
    |> Phoenix.View.render_to_string(template, assigns)
  end

  def notify_uploaded_images_to_users(grouped_images, status) do
    {title, template} =
      case status do
        "approved" ->
          {"Your photo(s) was approved 🙌🏿.", "approved_images.html"}

        "denied" ->
          {"Your photo(s) was denied.", "denied_images.html"}

        "featured" ->
          {"Your photo(s) is featured.", "featured_images.html"}
      end

    grouped_images
    |> Enum.each(fn {username, images} ->
      email = hd(images).user.email

      assigns = [
        username: username,
        title: title,
        images: images
      ]

      html_body = compose_html_body(template, assigns)

      deliver(email, assigns[:title], html_body)
    end)
  end

  def deliver_welcome_message(user) do
    assigns = [
      username: user.username,
      title: "Welcome to Nappy"
    ]

    html_body = compose_html_body("welcome.html", assigns)

    deliver(user.email, assigns[:title], html_body)
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    assigns = [
      url: url,
      user_email: user.email,
      title: "Verify your Email Address"
    ]

    html_body = compose_html_body("send_confirmation.html", assigns)

    deliver(user.email, assigns[:title], html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    assigns = [
      url: url,
      user_email: user.email,
      title: "Reset password instructions"
    ]

    html_body = compose_html_body("send_reset_password.html", assigns)

    deliver(user.email, assigns[:title], html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
