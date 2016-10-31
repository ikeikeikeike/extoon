defmodule Extoon.Repo.Migrations.AddGinIndexIntoInfoOnCrawl do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX crawls_info_gin_index ON crawls USING GIN (info);"
  end

  def down do
    execute "DROP INDEX crawls_info_gin_index;"
  end
end
