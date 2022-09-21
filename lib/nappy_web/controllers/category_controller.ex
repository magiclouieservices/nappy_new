defmodule NappyWeb.CategoryController do
  use NappyWeb, :controller
  alias Nappy.Catalog

  def index(conn, _params) do
    categories = Catalog.list_categories()
    render(conn, "index.html", categories: categories)
  end
end
