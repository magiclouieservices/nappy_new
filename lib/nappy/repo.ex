defmodule Nappy.Repo do
  use Ecto.Repo,
    otp_app: :nappy,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 12
  alias Ecto.Adapters.SQL

  def execute_and_load(sql, params, model) do
    SQL.query!(__MODULE__, sql, params)
    |> load_into(model)
  end

  def test_query(sql, params) do
    SQL.query!(__MODULE__, sql, params)
  end

  defp load_into(response, _model) do
    Enum.map(response.rows, fn row ->
      # fields =
      Enum.reduce(
        Enum.zip(response.columns, row),
        %{},
        fn {key, value}, map ->
          Map.put(map, key, value)
        end
      )

      # __MODULE__.load(model, fields)
    end)
  end

  # Repo.query("select * from images TABLESAMPLE system_rows($1)", [12])

  # Repo.test_query("select * from images TABLESAMPLE system_rows($1) where image_status_id = $2 or image_status_id = $3;", [3, Ecto.UUID.dump!("57107a38-736d-4b0b-817e-656dcdda8d77"), Ecto.UUID.dump!("d6122924-9dfc-42e0-b178-d2051b259bac")])

  # Repo.execute_and_load("select * from images TABLESAMPLE system_rows($1) where image_status_id = $2 or image_status_id = $3;", [3, Ecto.UUID.dump!("57107a38-736d-4b0b-817e-656dcdda8d77"), Ecto.UUID.dump!("d6122924-9dfc-42e0-b178-d2051b259bac")], Images)
end
