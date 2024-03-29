defmodule Nappy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nappy.Accounts
  alias Nappy.Accounts.AccountRole
  alias Nappy.Accounts.AccountStatus
  alias Nappy.Accounts.SocialMedia
  alias Nappy.Catalog.Image
  alias Nappy.Newsletter.Subscriber

  @moduledoc false

  @derive {Phoenix.Param, key: :username}
  schema "users" do
    field :email, :string
    field :username, :string
    field :slug, :string
    field :name, :string
    belongs_to :account_status, AccountStatus
    belongs_to :account_role, AccountRole
    has_one :social_media, SocialMedia
    has_one :subscriber, Subscriber
    has_many :images, Image
    field :avatar_link, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :email,
      :username,
      :name,
      :slug,
      :avatar_link,
      :password,
      :account_status_id,
      :account_role_id
    ])
    |> validate_required([
      :slug,
      :username,
      :account_status_id,
      :account_role_id
    ])
    |> foreign_key_constraint(:account_role_id)
    |> foreign_key_constraint(:account_status_id)
    |> unique_constraint(:slug)
    |> validate_username()
    |> validate_email()
    |> validate_password(opts)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_length(:username, min: 3, max: 30)
    |> validate_format(:username, ~r/^[a-zA-Z0-9]+$/, message: "only letters and numbers allowed")
    |> unsafe_validate_unique(:username, Nappy.Repo)
    |> unique_constraint(:username)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Nappy.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[0-9]/, message: "at least one number")
    |> validate_format(:password, ~r/[!?@#$%^&*_]/, message: "at least one symbol")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the username/name.
  """
  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_username()
    |> validate_required([:username])
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    account_status_id = Accounts.get_user_status_id(:active)

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    change(user, %{confirmed_at: now, account_status_id: account_status_id})
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Nappy.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end

defimpl SEO.OpenGraph.Build, for: Nappy.Accounts.User do
  alias Nappy.Accounts
  alias NappyWeb.Router.Helpers, as: Routes

  def build(user, conn) do
    SEO.OpenGraph.build(
      detail: SEO.OpenGraph.Profile.build(username: user.username),
      image: image(user, conn),
      title: "#{user.username}'s Profile",
      description: user.social_media.bio || "#{user.username}'s Profile"
    )
  end

  defp image(user, _conn) do
    ext = if user.avatar_link, do: Path.extname(user.avatar_link), else: ".jpeg"

    SEO.OpenGraph.Image.build(
      alt: "#{user.username}'s Profile",
      height: Accounts.default_avatar_height(),
      width: Accounts.default_avatar_width(),
      type: ext,
      url: Accounts.avatar_url(user.avatar_link)
    )
  end
end

defimpl SEO.Site.Build, for: Nappy.Accounts.User do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(user, conn) do
    SEO.Site.build(
      url: Routes.user_profile_show_url(conn, :show, user.username),
      title: "#{user.username}'s Profile",
      description: user.social_media.bio || "#{user.username}'s Profile"
    )
  end
end

defimpl SEO.Twitter.Build, for: Nappy.Accounts.User do
  def build(user, _conn) do
    SEO.Twitter.build(
      description: user.social_media.bio || "#{user.username}'s Profile",
      title: "#{user.username}'s Profile"
    )
  end
end

defimpl SEO.Unfurl.Build, for: Nappy.Accounts.User do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(user, conn) do
    SEO.Unfurl.build(
      label1: "username",
      data1: user.username,
      label2: "#{user.username}'s Profile",
      data2: Routes.user_profile_show_url(conn, :show, user.username)
    )
  end
end

defimpl SEO.Breadcrumb.Build, for: Nappy.Accounts.User do
  alias NappyWeb.Router.Helpers, as: Routes

  def build(user, conn) do
    SEO.Breadcrumb.List.build([
      %{name: "Profile details", item: Routes.user_profile_show_path(conn, :show, user.username)}
    ])
  end
end
