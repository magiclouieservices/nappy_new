defmodule Nappy.GlobalSetup do
  @moduledoc """
  Global setup for initial data (Postgres)
  """

  alias Nappy.Accounts.AccountRole
  alias Nappy.Accounts.AccountStatus
  alias Nappy.Admin
  alias Nappy.Admin.SeoDetail
  alias Nappy.Builder.Page
  alias Nappy.Catalog.Category
  alias Nappy.Metrics.ImageStatus
  alias Nappy.Newsletter.Referrer
  alias Nappy.Repo

  @doc """
  Some data that needs to be initialised in
  the database (Postgres). Please do note that
  this seeding is only been tested on single
  instance and not been used with replication,
  multiple nodes.
  """
  def init_seed do
    unless Repo.exists?(AccountRole) do
      Repo.transaction(fn ->
        Repo.insert_all(AccountRole, [
          [name: :normal],
          [name: :contributor],
          [name: :admin]
        ])

        Repo.insert_all(AccountStatus, [
          [name: :pending],
          [name: :active],
          [name: :banned]
        ])

        Repo.insert_all(Referrer, [
          [name: "Nappy Website"],
          [name: "Facebook"],
          [name: "Google"],
          [name: "Twitter"],
          [name: "Instagram"]
        ])

        Repo.insert_all(ImageStatus, [
          [name: :pending],
          [name: :active],
          [name: :denied],
          [name: :featured]
        ])

        Repo.insert_all(Category, [
          [name: "Other", slug: "other", is_enabled: true],
          [name: "Food", slug: "food", is_enabled: true],
          [name: "Places", slug: "places", is_enabled: true],
          [name: "Objects", slug: "objects", is_enabled: true],
          [name: "Work", slug: "work", is_enabled: true],
          [name: "Active", slug: "active", is_enabled: true],
          [name: "NSFW", slug: "nsfw", is_enabled: true]
        ])

        inserted_at =
          NaiveDateTime.utc_now()
          |> NaiveDateTime.truncate(:second)

        Repo.insert_all(SeoDetail, [
          [
            title: "All photos",
            description: "All photos that are verified by Nappy team and uploaded by users.",
            type: "all",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ],
          [
            title: "Featured photos",
            description: "Featured photos are handpicked and curated by Nappy team.",
            type: "featured",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ],
          [
            title: "Popular photos",
            description: "These are the most viewed picks of Black and Brown People.",
            type: "popular",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ],
          [
            title: "Collections",
            description: "Handpicked and curated photos grouped as collectons.",
            type: "collections",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ],
          [
            title: "Categories",
            description: "Photos tagged according to their categories.",
            type: "categories",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ],
          [
            title: "Search",
            description: "Search for photos",
            type: "search",
            inserted_at: inserted_at,
            updated_at: inserted_at
          ]
        ])

        Repo.insert_all(
          Page,
          ~w(why studio contact about terms faq)
          |> Enum.map(
            &[
              title: &1 <> " title",
              content: &1 <> " content",
              slug: &1,
              is_enabled: true,
              inserted_at: inserted_at,
              updated_at: inserted_at
            ]
          )
        )

        Admin.create_settings(%{
          allow_downloads: false,
          allow_oauth_login: false,
          allow_registration: false,
          allow_uploads: false,
          enable_captcha: false,
          image_per_page: 12,
          maintenance_enabled: false,
          max_concurrent_upload: 10,
          max_image_upload_size: 50_000_000,
          max_tag_count: 20,
          min_height_upload_image: 1024,
          min_width_upload_image: 768,
          notifier_email: Nappy.notifications_email(),
          support_email: Nappy.support_email()
        })
      end)

      # Code.compile_file("lib/nappy_web/router.ex")
    end
  end
end
