defmodule NappyWeb.LiveInitAssigns do
  import Phoenix.LiveView
  import Phoenix.Component

  alias Nappy.Catalog

  @moduledoc false

  @cache_name Nappy.cache_name()
  @default_ttl :timer.seconds(15)

  def on_mount(:load_images, params, _session, socket) do
    images =
      case params do
        %{"filter" => filter} when filter in ["popular", "all"] ->
          with_cache("#{filter}-images-homepage", fn ->
            filter = String.to_existing_atom(filter)
            Catalog.paginate_images(filter, page: 1)
          end)

        _ ->
          with_cache("featured-images-homepage", fn ->
            Catalog.paginate_images(:featured, page: 1)
          end)
      end

    {
      :cont,
      socket
      |> assign(images: images)
    }
  end

  def with_cache(key, fun) do
    case Cachex.get(@cache_name, key) do
      {:ok, nil} ->
        result = fun.()
        Cachex.put(@cache_name, key, result, ttl: @default_ttl)
        result

      {:ok, result} ->
        result
    end
  end
end
