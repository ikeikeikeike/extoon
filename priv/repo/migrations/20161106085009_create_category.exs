defmodule Extoon.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      timestamps()
    end
    create unique_index(:categories, [:name, :alias], name: :categories_name_alias_index)

    create index(:categories, [:name])
    create index(:categories, [:gyou])
  end
end
