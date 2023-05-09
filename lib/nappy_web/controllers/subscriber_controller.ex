defmodule NappyWeb.SubscriberController do
  use NappyWeb, :controller

  def confirm(conn, _params) do
    render(conn, "confirm.html")
  end

  def confirmed(conn, _params) do
    render(conn, "confirmed.html")
  end
end
