import Ecto.{Changeset, Query}
import Logger

alias ExAws.{S3}
alias Image, as: ExtractImage
alias Nappy.{Accounts, Admin, Builder, Catalog, Metrics, Newsletter, Repo}
alias Nappy.Accounts.{AccountRole, AccountStatus, SocialMedia, User, UserToken}
alias Nappy.Admin.{AdminSettings, Legal, SeoDetail, Slug}
alias Nappy.Builder.{Page}
alias Nappy.Catalog.{Category, Collection, ImageCollection}
alias Nappy.Metrics.{ImageAnalytics, ImageMetadata, ImageStatus, Notifications}
alias Nappy.Newsletter.{Referrer, Subscriber}
alias Nappy.Search
alias Nappy.SponsoredImages
alias NappyWeb.Router.Helpers, as: Routes
alias NappyWeb.Endpoint
alias NappyWeb.Uploaders.Avatar

# IEx.configure(
#   inspect: [
#     limit: :infinity,
#     printable_limit: :infinity
#   ]
# )

Logger.info("Most modules are aliased now, with ecto, routes and endpoint")
