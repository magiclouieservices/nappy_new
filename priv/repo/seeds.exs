# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nappy.Repo.insert!(%Nappy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# running this file (seeds.ex) like:
# mix run priv/repo/seeds.exs

import Ecto.{Changeset, Query}

alias Nappy.{Accounts, Admin, Builder, Catalog, GlobalSetup, Repo}
alias Nappy.Accounts.{AccountRole, AccountStatus, SocialMedia, User, UserToken}
alias Nappy.Admin.{Slug}
alias Nappy.Builder.{Page}
alias NappyWeb.Router.Helpers, as: Routes
alias NappyWeb.Endpoint

# init user roles and status
GlobalSetup.init_seed()

# [
#   {"Other", "other", 9, true},
#   {"Food", "food", 9, true},
#   {"People", "people", 9, true},
#   {"Places", "places", 9, true},
#   {"Objects", "objects", 9, true},
#   {"Work", "work", 9, true},
#   {"Active", "active", 9, true},
#   {"NSFW", "nsfw", 9, true}
# ]
# |> Enum.each(fn {name, slug, thumbnail, is_enabled} ->
#   Catalog.create_category(%{
#     name: name,
#     slug: slug,
#     thumbnail: thumbnail,
#     is_enabled: is_enabled
#   })
# end)

# [
#   "why",
#   "studio",
#   "contact",
#   "about",
#   "terms",
#   "faq"
# ]
# |> Enum.each(fn page ->
#   Builder.create_page(%{
#     title: page <> "title",
#     content: page <> "content",
#     slug: page,
#     thumbnail: Enum.random(1..99),
#     is_enabled: Enum.random([true, false])
#   })
# end)

# Code.compile_file("lib/nappy_web/router.ex")
