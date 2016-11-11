defmodule Extoon.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :outline, :text

      timestamps()
    end
    create index(:tags, [:name], unique: true)
    create index(:tags, [:gyou])
  end

end
