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

Nappy.GlobalSetup.init_seed()
