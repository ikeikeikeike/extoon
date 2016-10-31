defmodule Extoon.Repo.Migrations.CreateCrawl do
  use Ecto.Migration

  def change do
    create table(:crawls) do
      add :state, :string
      add :name, :string
      add :info, :map

      timestamps()
    end
    create index(:crawls, [:state])

  end
end
