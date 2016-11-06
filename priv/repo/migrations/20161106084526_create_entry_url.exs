defmodule Extoon.Repo.Migrations.CreateEntryUrl do
  use Ecto.Migration

  def change do
    create table(:entries_urls) do
      add :entry_id, :integer
      add :url, :text

      timestamps()
    end
    create index(:entries_urls, [:entry_id])

  end
end
