defmodule NappyWeb.FallbackController do
  use Phoenix.Controller

  alias Plug.Conn.Status

  defexception [:message, :plug_status]

  @doc """
  HTTP status codes can be found [here](https://hexdocs.pm/plug/Plug.Conn.Status.html)
  Used to raise an error (render error page) for LiveView.

  ## Examples
    alias Plug.Conn.Status

    raise NappyWeb.FallbackController, Status.code(:not_found)

  """
  def exception(message) do
    %__MODULE__{
      message: Status.reason_phrase(message),
      plug_status: message
    }
  end

  @impl true
  def call(conn, {:error, status_name}) do
    status_code = Status.code(status_name)

    conn
    |> put_status(status_name)
    |> put_view(NappyWeb.ErrorView)
    |> render("#{status_code}.html")
  end
end
