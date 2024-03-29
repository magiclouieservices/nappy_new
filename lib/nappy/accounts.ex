defmodule Nappy.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Nappy.Accounts.AccountRole
  alias Nappy.Accounts.AccountStatus
  alias Nappy.Accounts.SocialMedia
  alias Nappy.Accounts.User
  alias Nappy.Accounts.UserNotifier
  alias Nappy.Accounts.UserToken
  alias Nappy.Catalog
  alias Nappy.Repo

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Nappy.PubSub, "user-#{user_id}")
  end

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_slug(slug) when is_binary(slug) do
    Repo.get_by(User, slug: slug)
  end

  def get_user_by_username(username) when is_binary(username) do
    User
    |> where(username: ^username)
    |> preload(:social_media)
    |> Repo.one!()
  end

  def get_username_by_id(id) when is_integer(id) do
    query =
      from u in User,
        where: u.id == ^id,
        select: u.username

    Repo.one(query)
  end

  def default_avatar_width, do: 1260
  def default_avatar_height, do: 750

  def avatar_url(avatar_link, query \\ nil) do
    if avatar_link do
      host = Nappy.image_src_host()
      path = Path.join(["/", "avatar", avatar_link])

      query =
        if query do
          %{
            auto: "compress",
            cs: "tinysrgb",
            w: default_avatar_width(),
            h: default_avatar_height()
          }
          |> URI.encode_query()
        else
          query
        end

      Catalog.image_url(host, path, query)
    else
      host = Nappy.nappy_host()
      path = Path.join(["/", "images", "empty-avatar.jpeg"])

      %URI{
        scheme: "https",
        host: host,
        path: path
      }
      |> URI.to_string()
    end
  end

  @doc """
  Gets a user by email or username and password.

  ## Examples

      iex> get_user_by_email_or_username_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_or_username_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_or_username_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_or_username_and_password(email_or_username, password)
      when is_binary(email_or_username) and is_binary(password) do
    user =
      Repo.get_by(User, email: email_or_username) ||
        Repo.get_by(User, username: email_or_username)

    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_role_id(role) do
    query =
      from r in AccountRole,
        where: r.name == ^role,
        select: r.id

    Repo.one(query)
  end

  def is_admin(%User{} = user) do
    query =
      from r in AccountRole,
        where: r.id == ^user.account_role_id,
        select: r.name

    Repo.one(query) === :admin
  end

  def is_admin(_), do: false

  def is_admin_or_contributor(_user, roles \\ [:admin, :contributor])

  def is_admin_or_contributor(%User{} = user, roles) do
    user.account_role_id in Enum.map(roles, &get_user_role_id/1)
  end

  def is_admin_or_contributor(_user, _roles), do: false

  def get_user_status_id(status) do
    # Ecto.Enum.values(User, :status)
    query =
      from s in AccountStatus,
        where: s.name == ^status,
        select: s.id

    Repo.one(query)
  end

  def get_account_status_name(status_id) do
    query =
      from as in AccountStatus,
        where: as.id == ^status_id,
        select: as.name

    Repo.one(query)
  end

  def create_role(%AccountRole{} = account_role, attrs \\ %{}) do
    AccountRole.changeset(account_role, attrs)
  end

  def create_status(%AccountStatus{} = account_status, attrs \\ %{}) do
    AccountStatus.changeset(account_status, attrs)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    pending = get_user_status_id(:pending)
    normal = get_user_role_id(:normal)

    attrs =
      attrs
      |> Map.put("account_status_id", pending)
      |> Map.put("account_role_id", normal)
      |> Map.put("slug", Nanoid.generate())

    with {:ok, user} <-
           %User{}
           |> User.registration_changeset(attrs)
           |> Repo.insert(),
         {:ok, _social_media} <-
           user
           |> Ecto.build_assoc(:social_media, %{})
           |> SocialMedia.changeset(%{})
           |> Repo.insert() do
      {:ok, user}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  def change_user(user, attrs \\ %{}) do
    User.user_changeset(user, attrs)
  end

  def change_social_media(user_id, attrs \\ %{}) do
    SocialMedia
    |> where(user_id: ^user_id)
    |> Repo.one()
    |> SocialMedia.changeset(attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc """
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def update_user(user, attrs) do
    changeset =
      user
      |> User.user_changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def update_social_media(user_id, attrs) do
    changeset =
      SocialMedia
      |> where(user_id: ^user_id)
      |> Repo.one()
      |> SocialMedia.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:social_media, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{social_media: social_media}} -> {:ok, social_media}
      {:error, :social_media, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
    |> Ecto.Multi.run(:notify_user, fn _repo, %{user: user} ->
      UserNotifier.deliver_welcome_message(user)
      {:ok, user}
    end)
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
