defmodule Extoon.Repo.Migrations.CreateLabel do
  use Ecto.Migration

  def change do
    create table(:labels) do
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
    create unique_index(:labels, [:name, :alias], name: :labels_name_alias_index)

    create index(:labels, [:name])
    create index(:labels, [:gyou])

  end
end
