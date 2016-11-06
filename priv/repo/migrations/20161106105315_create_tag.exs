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
    create unique_index(:tags, [:name, :alias], name: :tags_name_alias_index)

    create index(:tags, [:name])
    create index(:tags, [:gyou])
  end

end
