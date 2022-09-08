defmodule Nappy.Migration do
  @moduledoc false

  defmacro __using__(opts) do
    lock_timeout = Keyword.get(opts, :lock_timeout, up: "5s", down: "10s")

    quote do
      use Ecto.Migration

      if unquote(lock_timeout) do
        def after_begin do
          execute(
            "SET LOCAL lock_timeout TO '#{Keyword.fetch!(unquote(lock_timeout), :up)}'",
            "SET LOCAL lock_timeout TO '#{Keyword.fetch!(unquote(lock_timeout), :down)}'"
          )
        end
      end
    end
  end
end
