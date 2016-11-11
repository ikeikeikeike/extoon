defmodule Extoon.Repo.Migrations.CreateMaker do
  use Ecto.Migration

  def change do
    create table(:makers) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :url, :string
      add :outline, :string

      timestamps()
    end
    create index(:makers, [:name], unique: true)
    create index(:makers, [:gyou])

  end
end
