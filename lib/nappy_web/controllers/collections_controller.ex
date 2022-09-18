defmodule NappyWeb.CollectionsController do
  use NappyWeb, :controller
  alias Nappy.Catalog

  def index(conn, _params) do
    collections = Catalog.list_collection_description()
    render(conn, "index.html", collections: collections)
  end
end
