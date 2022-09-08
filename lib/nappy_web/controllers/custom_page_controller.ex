defmodule NappyWeb.CustomPageController do
  use NappyWeb, :controller

  alias Nappy.Builder

  def index(conn, _params) do
    <<_slash::utf8, slug_name::binary>> = conn.request_path

    page = Builder.get_page_by_slug_name(slug_name)

    render(conn, "index.html", page: page)
  end
end
