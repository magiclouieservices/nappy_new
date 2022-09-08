defmodule Nappy.GlobalSetup do
  @moduledoc """
  Global setup for initial data (Postgres)
  """

  alias Nappy.Admin
  alias Nappy.Accounts.{AccountRole, AccountStatus}
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
  end
end
