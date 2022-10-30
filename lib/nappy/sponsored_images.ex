defmodule Nappy.SponsoredImages do
  @moduledoc false

  @default_ttl_seconds "1599"

  def get_images(key_name, tags, page_size \\ 5) do
    tag =
      tags
      |> String.split(",", trim: true)
      |> hd()

    cache_name = "#{key_name}-#{tag}"
    cache = Nappy.cache_name() |> Cachex.get(cache_name)

    case cache do
      {:ok, nil} ->
        token = get_access_key("token-#{key_name}")

        opts = [
          base_url: "https://api.gettyimages.com/v3/search/images",
          headers: [api_key: Nappy.getty_api_key()],
          compressed: true,
          auth: {:bearer, token},
          retry: fn %Req.Response{status: status} ->
            cond do
              status in [408, 401, 429] -> true
              status in 500..599 -> true
              true -> false
            end
          end,
          params: [
            compositions: "candid",
            ethnicity: "black",
            exclude_editorial_use_only: false,
            fields: "comp,referral_destinations,summary_set",
            number_of_people: "one,two,group",
            orientations: "Horizontal",
            phrase: tag,
            sort_order: "best_match",
            page_size: page_size
          ]
        ]

        %Req.Response{body: %{"images" => images}} = Req.get!("/creative", opts)

        payload =
          Enum.map(images, fn image ->
            image_alt = image["title"]

            image_src =
              image["display_sizes"]
              |> Enum.filter(&(&1["name"] === "comp"))
              |> hd()
              |> Map.get("uri")

            referral_link =
              image["referral_destinations"]
              |> Enum.filter(&(&1["site_name"] === "istockphoto"))
              |> hd()
              |> Map.get("uri")

            %{
              "image_alt" => image_alt,
              "image_src" => image_src,
              "referral_link" => referral_link
            }
          end)

        put_cache(cache_name, payload)

      {:ok, body} ->
        body
    end
  end

  def get_access_key(key_name) do
    cache = Nappy.cache_name() |> Cachex.get(key_name)

    case cache do
      {:ok, nil} ->
        opts = [
          form: [
            grant_type: "client_credentials",
            client_id: Nappy.getty_api_key(),
            client_secret: Nappy.getty_api_secret()
          ],
          base_url: "https://api.gettyimages.com/oauth2",
          compressed: true,
          retry: fn %Req.Response{status: status} ->
            cond do
              status in [408, 401, 429] -> true
              status in 500..599 -> true
              true -> false
            end
          end
        ]

        %Req.Response{
          body: %{
            "access_token" => token,
            "expires_in" => expires_in
          }
        } = Req.post!("/token", opts)

        put_cache(key_name, token, expires_in)

      {:ok, token} ->
        token
    end
  end

  defp put_cache(cache_name, payload) do
    put_cache(cache_name, payload, @default_ttl_seconds)
  end

  defp put_cache(cache_name, payload, ttl) do
    ttl =
      ttl
      |> Integer.parse()
      |> elem(0)
      |> :timer.seconds()

    {:ok, _} =
      Nappy.cache_name()
      |> Cachex.put("#{cache_name}", payload, ttl: ttl)

    payload
  end
end
