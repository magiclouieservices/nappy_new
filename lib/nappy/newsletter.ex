defmodule Nappy.Newsletter do
  @moduledoc """
  The Newsletter context.
  """

  import Ecto.Query, warn: false
  alias Nappy.Repo

  alias Nappy.Accounts.User
  alias Nappy.Newsletter.Referrer
  alias Nappy.Newsletter.Subscriber

  @doc """
  Returns the list of subscribers.

  ## Examples

      iex> list_subscribers()
      [%Subscriber{}, ...]

  """
  def list_subscribers do
    Repo.all(Subscriber)
  end

  def get_referrer_id(referrer) do
    query =
      from r in Referrer,
        where: r.name == ^referrer,
        select: r.id

    Repo.one(query)
  end

  @doc """
  Gets a single subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscriber!(id), do: Repo.get!(Subscriber, id)

  def get_subscriber_by_username(username) do
    User
    |> where(username: ^username)
    |> preload(:subscriber)
    |> Repo.one()
    |> Map.get(:subscriber)
  end

  @doc """
  Creates a subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscriber(attrs \\ %{}) do
    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()
  end

  def get_active_subscriber_count(list_id) do
    options = [
      form: [
        api_key: Nappy.sendy_api_key(),
        list_id: list_id
      ]
    ]

    url = Nappy.subscription_url("api/subscribers/active-subscriber-count.php")
    %Req.Response{status: 200, body: body} = Req.post!(url, options)

    case Integer.parse(body) do
      {count, _} -> count
      :error -> 0
    end
  end

  def subscribe_newsletter(username, email, list_id) do
    options = [
      form: [
        api_key: Nappy.sendy_api_key(),
        list: list_id,
        name: username,
        email: email
      ]
    ]

    url = Nappy.subscription_url("subscribe")
    Req.post!(url, options)
  end

  def unsubscribe_newsletter(email, list_id) do
    options = [
      form: [
        api_key: Nappy.sendy_api_key(),
        list: list_id,
        email: email,
        boolean: true
      ]
    ]

    url = Nappy.subscription_url("unsubscribe")
    Req.post!(url, options)
  end

  def delete_subscriber(email, list_id) do
    options = [
      form: [
        api_key: Nappy.sendy_api_key(),
        list_id: list_id,
        email: email,
        boolean: true
      ]
    ]

    url = Nappy.subscription_url("api/subscribers/delete.php")
    Req.post!(url, options)
  end

  @doc """
  Updates a subscriber.

  ## Examples

      iex> update_subscriber(subscriber, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscriber(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscriber.

  ## Examples

      iex> delete_subscriber(subscriber)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(subscriber)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscriber(%Subscriber{} = subscriber) do
    Repo.delete(subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscriber changes.

  ## Examples

      iex> change_subscriber(subscriber)
      %Ecto.Changeset{data: %Subscriber{}}

  """
  def change_subscriber(%Subscriber{} = subscriber, attrs \\ %{}) do
    Subscriber.changeset(subscriber, attrs)
  end

  alias Nappy.Newsletter.Referrer

  @doc """
  Returns the list of referrers.

  ## Examples

      iex> list_referrers()
      [%Referrer{}, ...]

  """
  def list_referrers do
    Repo.all(Referrer)
  end

  @doc """
  Gets a single referrer.

  Raises `Ecto.NoResultsError` if the Referrer does not exist.

  ## Examples

      iex> get_referrer!(123)
      %Referrer{}

      iex> get_referrer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_referrer!(id), do: Repo.get!(Referrer, id)

  @doc """
  Creates a referrer.

  ## Examples

      iex> create_referrer(%{field: value})
      {:ok, %Referrer{}}

      iex> create_referrer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_referrer(attrs \\ %{}) do
    %Referrer{}
    |> Referrer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a referrer.

  ## Examples

      iex> update_referrer(referrer, %{field: new_value})
      {:ok, %Referrer{}}

      iex> update_referrer(referrer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_referrer(%Referrer{} = referrer, attrs) do
    referrer
    |> Referrer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a referrer.

  ## Examples

      iex> delete_referrer(referrer)
      {:ok, %Referrer{}}

      iex> delete_referrer(referrer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_referrer(%Referrer{} = referrer) do
    Repo.delete(referrer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking referrer changes.

  ## Examples

      iex> change_referrer(referrer)
      %Ecto.Changeset{data: %Referrer{}}

  """
  def change_referrer(%Referrer{} = referrer, attrs \\ %{}) do
    Referrer.changeset(referrer, attrs)
  end
end
