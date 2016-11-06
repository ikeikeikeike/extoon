defmodule Extoon.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :identifier, :integer

      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :url, :string
      add :outline, :string

      timestamps()
    end
    create unique_index(:series, [:name, :alias], name: :series_name_alias_index)

    create index(:series, [:name])
    create index(:series, [:gyou])

  end
end
