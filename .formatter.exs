[
  import_deps: [:ecto, :phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs:
    [
      "*.{heex,ex,exs}",
      "priv/*/seeds.exs",
      "{config,lib,test}/**/*.{heex,ex,exs}"
    ]
    |> Enum.flat_map(&Path.wildcard(&1, match_dot: true))
    |> Enum.reject(&(&1 =~ "lib/nappy_web/templates/layout/live.html.heex")),
  subdirectories: ["priv/*/migrations"]
]
