defmodule Extoon.Repo.Migrations.AddGinIndexIntoInfoOnEntryInfo do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX entries_infos_info_gin_index ON entries_infos USING GIN (info);"
  end

  def down do
    execute "DROP INDEX entries_infos_info_gin_index;"
  end
end
