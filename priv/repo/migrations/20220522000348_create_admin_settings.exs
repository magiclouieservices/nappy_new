defmodule Nappy.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:admin_settings) do
      add :notifier_email, :string,
        null: false,
        comment:
          "Site notifications like email verification, welcome note after signups, newsletters, etc. for users."

      add :support_email, :string,
        null: false,
        comment:
          "Email for receiving inquiries about our product(s) and provide technical support to users."

      add :allow_registration, :boolean, default: false, null: false
      add :allow_uploads, :boolean, default: false, null: false
      add :allow_downloads, :boolean, default: false, null: false
      add :allow_oauth_login, :boolean, default: false, null: false
      add :enable_captcha, :boolean, default: false, null: false
      add :maintenance_enabled, :boolean, default: false, null: false

      add :image_per_page, :integer,
        null: false,
        comment: "Number of images shown before infinite scroll is triggered"

      add :max_tag_count, :integer,
        null: false,
        comment: "Max number of tags allowed for each image"

      add :max_image_upload_size, :integer,
        null: false,
        comment: "Max single upload size (e.g. 8,000,000 is 8MB)"

      add :max_concurrent_upload, :integer,
        null: false,
        comment:
          "Intended for bulk uploads, this is how many images are being uploaded simultaneously."

      add :min_width_upload_image, :integer, null: false
      add :min_height_upload_image, :integer, null: false
    end
  end
end
