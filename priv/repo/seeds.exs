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

[
  {"Other", "other"},
  {"Food", "food"},
  {"People", "people"},
  {"Places", "places"},
  {"Objects", "objects"},
  {"Work", "work"},
  {"Active", "active"},
  {"NSFW", "nsfw"}
]
|> Enum.each(fn {name, slug} ->
  Builder.create_category(%{
    name: name,
    slug: slug,
    is_enabled: Enum.random([true, false])
  })
end)

default_thumbnail = fn ->
  query =
    from i in Target.Images,
      limit: 1,
      select: i.id

  TargetRepo.one(query)
end

[
  "why",
  "studio",
  "contact",
  "about",
  "terms",
  "faq"
]
|> Enum.each(fn page ->
  Builder.create_page(%{
    title: page <> "title",
    content: page <> "content",
    slug: page,
    thumbnail: default_thumbnail.(),
    is_enabled: Enum.random([true, false])
  })
end)

# Code.compile_file("lib/nappy_web/router.ex")
