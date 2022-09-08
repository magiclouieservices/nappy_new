defmodule NappyWeb.LegalController do
  use NappyWeb, :controller

  alias Nappy.Admin
  alias Nappy.Admin.Legal

  def index(conn, _params) do
    legal = Admin.list_legal()
    render(conn, "index.html", legal: legal)
  end

  def new(conn, _params) do
    changeset = Admin.change_legal(%Legal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"legal" => legal_params}) do
    case Admin.create_legal(legal_params) do
      {:ok, legal} ->
        conn
        |> put_flash(:info, "Legal created successfully.")
        |> redirect(to: Routes.legal_path(conn, :show, legal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    legal = Admin.get_legal!(id)
    render(conn, "show.html", legal: legal)
  end

  def edit(conn, %{"id" => id}) do
    legal = Admin.get_legal!(id)
    changeset = Admin.change_legal(legal)
    render(conn, "edit.html", legal: legal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "legal" => legal_params}) do
    legal = Admin.get_legal!(id)

    case Admin.update_legal(legal, legal_params) do
      {:ok, legal} ->
        conn
        |> put_flash(:info, "Legal updated successfully.")
        |> redirect(to: Routes.legal_path(conn, :show, legal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", legal: legal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    legal = Admin.get_legal!(id)
    {:ok, _legal} = Admin.delete_legal(legal)

    conn
    |> put_flash(:info, "Legal deleted successfully.")
    |> redirect(to: Routes.legal_path(conn, :index))
  end
end
