defmodule Nappy.Repo do
  use Ecto.Repo,
    otp_app: :nappy,
    adapter: Ecto.Adapters.Postgres
end
