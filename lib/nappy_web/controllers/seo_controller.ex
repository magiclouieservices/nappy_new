defmodule NappyWeb.SeoController do
  use NappyWeb, :controller

  alias Nappy.Admin
  alias Nappy.Admin.Seo

  def index(conn, _params) do
    seo = Admin.list_seo()
    render(conn, "index.html", seo: seo)
  end

  def new(conn, _params) do
    changeset = Admin.change_seo(%Seo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seo" => seo_params}) do
    case Admin.create_seo(seo_params) do
      {:ok, seo} ->
        conn
        |> put_flash(:info, "Seo created successfully.")
        |> redirect(to: Routes.seo_path(conn, :show, seo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seo = Admin.get_seo!(id)
    render(conn, "show.html", seo: seo)
  end

  def edit(conn, %{"id" => id}) do
    seo = Admin.get_seo!(id)
    changeset = Admin.change_seo(seo)
    render(conn, "edit.html", seo: seo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seo" => seo_params}) do
    seo = Admin.get_seo!(id)

    case Admin.update_seo(seo, seo_params) do
      {:ok, seo} ->
        conn
        |> put_flash(:info, "Seo updated successfully.")
        |> redirect(to: Routes.seo_path(conn, :show, seo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", seo: seo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    seo = Admin.get_seo!(id)
    {:ok, _seo} = Admin.delete_seo(seo)

    conn
    |> put_flash(:info, "Seo deleted successfully.")
    |> redirect(to: Routes.seo_path(conn, :index))
  end
end
