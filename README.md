# Nappy

## Setup

If you have Elixir already in your machine:

```yaml
version: "3.8"

services:
  postgres:
    image: postgres:14-alpine
    container_name: postgres
    cpu_count: 1
    cpus: 0.5
    cpu_percent: 30
    mem_limit: 500m
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=nappy_dev
    volumes:
      - ./priv/repo/nappy_dev.sql:/docker-entrypoint-initdb.d/nappy_dev.sql

  minio:
    image: bitnami/minio
    container_name: minio
    cpu_count: 1
    cpus: 0.5
    cpu_percent: 30
    mem_limit: 500m
    ports:
      - '9000:9000'
      - '9001:9001'
    environment:
      - MINIO_ROOT_USER=minio-root-user
      - MINIO_ROOT_PASSWORD=minio-root-password
      - MINIO_DEFAULT_BUCKETS=nappy,test-bucket
    volumes:
      - ./minio-persistence:/data
```

Also, you have to update runtime.exs (line 30-31, `embed_url`) in order to see your uploaded photos, pass some env vars then `docker-compose up -d`:

```elixir
config :nappy, :runtime,
  # ...
  notifications_email: "notifications@nappy.co",
  embed_url: System.get_env("IMGIX_URL", "http://localhost:9000"), # <-- this part
  image_path: System.get_env("WASABI_IMAGE_PATH", "/nappy/photos/") # <-- this part
```

## Install vips

If you're using via homebrew:

```bash
brew install vips
```

Or in *nix distro (e.g. `Ubuntu`)

```bash
# If build-essential is not installed
sudo apt install build-essential

# install glib and libvips
sudo apt install libglib2.0-dev libvips-dev
```

## S3 local upload behavior

Currently, all the images are pulled from imgIX. You need to follow this section if you want to try to **upload an image** and view it. We download the whole bucket (15+ Gb as of this commit) in order to test it locally. Don't forget to change line 30 in `runtime.exs` to `http://localhost:9000`.

### Setting up aws credentials:

```yaml
# path = ~/.aws/config
[profile wasabi]
region=us-east-2
output=table

# path = ~/.aws/credentials
[default]
aws_access_key_id=defaultaccesskeyid
aws_secret_access_key=defaultsecretaccesskey
[wasabi]
aws_access_key_id=wasabiaccesskeyid
aws_secret_access_key=wasabisecretaccesskey
```

### Download the bucket using docker aws cli:

> 15.1 Gb S3 bucket (2059 images as of this commit)

This is an inefficient way (and I currently know) of copying remote s3 to our minio local bucket.

```bash
# make sure the containers from compose file are up first.

docker container run --rm -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli s3 sync "s3://nappy-prod/" ./path/to/image_dir --profile wasabi --endpoint-url="https://s3.us-east-2.wasabisys.com"
```

```elixir
# MIX_ENV=dev iex -S mix

path = "path/to/image_dir"
files = File.ls!(path)

upload = fn filename ->
  path
  |> Path.join(filename)
  |> S3.Upload.stream_file()
  |> S3.upload(Nappy.bucket_name(), "photos/#{filename}")
  |> ExAws.request()
end

Enum.each(files, fn file ->
  upload.(file) |> IO.inspect()
end)
```

### Set the default value to point localhost:

```elixir
config :nappy, :runtime,
  # ...
  notifications_email: "notifications@nappy.co",
  embed_url: System.get_env("IMGIX_URL", "http://localhost:9000"), # <-- this part
  image_path: System.get_env("WASABI_IMAGE_PATH", "/nappy/photos/") # <-- this part
```

## Testing release build for Apple silicon host machine.

This is for testing what **prod** release build looks like when running. Please comment the last 2 lines of Dockerfile.

**Note**: Don't forget to uncomment it back before committing. The reason for that is it throws `Protocol 'inet6_tcp': register/listen error: eaddrnotavail` error which we're not using for local development.

```docker
# Remove ipv6 and erl_aflags env
# when deploying via vps
# Appended by flyctl
# ENV ECTO_IPV6 true
# ENV ERL_AFLAGS "-proto_dist inet6_tcp"
```

Next, we need to use a linux distro in order to build the release for executing it in our `docker-compose.yml` file.

The reason for that is because when running `mix release`, it uses our current OS arch which is different from our Docker builder image. Since our Dockerfile is using `prod` env, we'll generate a release based on that:

```bash
# For this example I'm pulling an Elixir 1.14 image
docker pull elixir:1.14.1

docker container run --rm -it -d -v $(pwd):/tmp --name elixir-build elixir:1.14.1

docker container exec -it elixir-build sh

apt update && apt install libvips-dev

MIX_ENV=prod mix release --overwrite

# exit running container
exit

# then copy _build/prod/rel/nappy outside of our container
docker container cp elixir-build:/tmp/_build/prod/rel/nappy/ _build/prod/rel/nappy
```

rename `nappy_dev.env.example` to `nappy_dev.env`, then `docker compose up -d`

For Linux: rename `nappy_dev.env.example` to `nappy_dev.env`, then `docker-compose up -d`

## Running test(s) on Windows (via wsl)

`chromedriver`: Go to https://chromedriver.storage.googleapis.com/index.html, then find the latest version to download

```bash
# skip these step if unzip is installed
sudo apt update && sudo apt install -y unzip

cd ~ && curl -O https://chromedriver.storage.googleapis.com/112.0.5615.28/chromedriver_linux64.zip
unzip chromedriver_linux64.zip && chmod +x chromedriver
mv chromedriver /usr/local/bin/
```

install chrome stable
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

# install missing dependencies if it's asking
```

then test

```bash
mix test --trace test/nappy_web/api/upload_images_test.exs
```

## Check for leaked secrets (optional)

This repo uses [zricethezav/gitleaks](https://github.com/zricethezav/gitleaks)

```bash
# e.g. macos
brew install gitleaks

# then run
gitleaks detect
```

## Fly.io specifics

```bash
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
