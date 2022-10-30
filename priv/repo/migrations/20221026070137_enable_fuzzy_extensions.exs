defmodule Nappy.Repo.Migrations.EnableFuzzyExtensions do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"

    execute("""
    CREATE MATERIALIZED VIEW image_search AS
    SELECT
      images.id AS id,
      images.tags AS tags,
      images.generated_tags AS generated_tags,
      images.title AS title,
      (
      setweight(to_tsvector(unaccent(images.title)), 'A') ||
      setweight(to_tsvector(unaccent(images.tags)), 'B') ||
      setweight(to_tsvector(unaccent(images.generated_tags)), 'C')
      ) AS search_document
    FROM images 
    GROUP BY images.id
    """)

    # to support full-text searches
    create index("image_search", ["search_document"], using: :gin)

    # to support substring title matches with ILIKE
    execute(
      "CREATE INDEX image_search_title_trgm_index ON image_search USING gin (title gin_trgm_ops)"
    )

    execute(
      "CREATE INDEX image_search_tags_trgm_index ON image_search USING gin (tags gin_trgm_ops)"
    )

    execute(
      "CREATE INDEX image_search_generated_tags_trgm_index ON image_search USING gin (generated_tags gin_trgm_ops)"
    )

    # to support updating CONCURRENTLY
    create unique_index("image_search", [:id])
  end

  def down do
    execute "DROP MATERIALIZED VIEW image_search"
    execute "DROP EXTENSION unaccent"
    execute "DROP EXTENSION fuzzystrmatch"
    execute "DROP EXTENSION pg_trgm"
  end
end
