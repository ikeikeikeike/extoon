defmodule Extoon.Repo.Migrations.CreateInfo do
  use Ecto.Migration

  def change do
    create table(:entries_infos) do
      add :assoc_id, :integer
      add :info, :map  # to be jsonb type

      timestamps()
    end
    create index(:entries_infos, [:assoc_id], unique: true)

  end
end
