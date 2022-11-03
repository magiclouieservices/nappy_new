# Nappy

<!--
### **NOTE BEFORE COMMITTING TO GIT!!!**

Please remove this line from `lib/nappy/release.ex`, as it's going to remove all data before bringing the repo up.

```elixir
# from migrate/0 function
{:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, all: true))
```
-->

### Dev environment, on first cloning of repo:

```bash
mix phx.gen.cert
mix deps.get
mix ecto.setup

# if you have sql file, copy inside the running container then import it
docker container cp path/to/import.sql container_name:/docker-entrypoint-initdb.d/import.sql

# run localhost Phoenix server
MIX_ENV=dev iex -S mix phx.server
```

### Check secrets

This repo uses [zricethezav/gitleaks](https://github.com/zricethezav/gitleaks)

```bash
# e.g. macos
brew install gitleaks

# then run
gitleaks detect

# Note: you can also add the
# command above for pre-commit
```

### Fly.io specifics

```bash
# 2 different environment sharing the same code
# current list of app names (APPNAME):
# - nappy-staging
# - nappy-prod

# then connect to db client (localhost)
# use db creds given from fly.io
# with localhost (127.0.0.1) as hostname
flyctl proxy 5432 -a APPNAME

# if deploying app fails, try attaching postgres to the app
flyctl postgres attach —app APPNAME —postgres-app PGNAME

# if it shows kernel panic where it cant find /app/bin/migrate
# that means it doesnt have release builds for migration:
mix phx.gen.release —ecto

# deploy with the right environment
flyctl deploy . \
  --app APPNAME \
  --config ./environment.toml \
  --dockerfile ./environment.dockerfile \
  --no-cache \
  --remote-only
```
