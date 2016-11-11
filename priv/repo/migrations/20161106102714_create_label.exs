defmodule Extoon.Repo.Migrations.CreateLabel do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :url, :string
      add :outline, :string

      timestamps()
    end
    create index(:labels, [:name], unique: true)
    create index(:labels, [:gyou])

  end
end
