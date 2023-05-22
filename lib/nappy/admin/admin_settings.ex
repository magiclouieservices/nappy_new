defmodule Nappy.Admin.AdminSettings do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "admin_settings" do
    field :notifier_email, :string, default: Nappy.notifications_email()
    field :support_email, :string, default: Nappy.support_email()
    field :allow_registration, :boolean, default: false
    field :allow_uploads, :boolean, default: false
    field :allow_downloads, :boolean, default: false
    field :allow_oauth_login, :boolean, default: false
    field :enable_captcha, :boolean, default: false
    field :maintenance_enabled, :boolean, default: false
    field :image_per_page, :integer, default: 12
    field :max_tag_count, :integer, default: 20
    field :max_image_upload_size, :integer, default: 50_000_000
    field :max_concurrent_upload, :integer, default: 10
    field :min_width_upload_image, :integer, default: 768
    field :min_height_upload_image, :integer, default: 1024
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [
      :notifier_email,
      :support_email,
      :allow_registration,
      :allow_uploads,
      :allow_downloads,
      :allow_oauth_login,
      :enable_captcha,
      :maintenance_enabled,
      :image_per_page,
      :max_tag_count,
      :max_image_upload_size,
      :max_concurrent_upload,
      :min_width_upload_image,
      :min_height_upload_image
    ])
    |> validate_required([
      :notifier_email,
      :support_email,
      :allow_registration,
      :allow_uploads,
      :allow_downloads,
      :allow_oauth_login,
      :enable_captcha,
      :maintenance_enabled,
      :image_per_page,
      :max_tag_count,
      :max_image_upload_size,
      :max_concurrent_upload,
      :min_width_upload_image,
      :min_height_upload_image
    ])
  end
end
