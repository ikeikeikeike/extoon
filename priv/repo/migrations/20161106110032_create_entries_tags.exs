defmodule Extoon.Repo.Migrations.CreateEntriesTags do
  use Ecto.Migration

  def change do
    create table(:entries_tags, primary_key: false) do
      add :entry_id, references(:entries)
      add :tag_id, references(:tags)
    end
    create index(:entries_tags,  [:tag_id, :entry_id], unique: true)
    create index(:entries_tags,  [:entry_id, :tag_id], unique: true)

  end
end
