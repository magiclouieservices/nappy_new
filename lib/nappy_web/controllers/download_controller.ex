defmodule NappyWeb.DownloadController do
  use NappyWeb, :controller

  def download(conn, params) do
    IO.inspect(params)
    send_download(conn, {:file, "test.txt"}, filename: "test.txt", disposition: :attachment)
  end
end
