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
    create index(:categories, [:name], unique: true)
    create index(:categories, [:gyou])
  end
end
