defmodule Extoon.Repo.Migrations.EntriesCreateThumb do
  use Ecto.Migration

  def change do
    create table(:entries_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :string
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps()
    end
    create index(:entries_thumbs, [:assoc_id])
    create index(:entries_thumbs, [:width])

  end
end
