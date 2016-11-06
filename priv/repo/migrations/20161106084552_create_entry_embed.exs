defmodule Extoon.Repo.Migrations.CreateEntryEmbed do
  use Ecto.Migration

  def change do
    create table(:entries_embeds) do
      add :entry_id, :integer
      add :code, :text

      timestamps()
    end
    create index(:entries_embeds, [:entry_id])

  end
end
