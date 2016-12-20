defmodule Extoon.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :maker_id, :integer
      add :label_id, :integer
      add :series_id, :integer
      add :category_id, :integer

      add :title, :text
      add :content, :text
      add :duration, :integer
      add :release_date, :date

      add :sort, :integer, default: nil

      # add :review, :boolean
      # add :removal, :boolean
      add :publish, :boolean, default: false
      add :published_at, :datetime

      timestamps()
    end
    create index(:entries, [:label_id])
    create index(:entries, [:series_id])
    create index(:entries, [:maker_id])
    create index(:entries, [:category_id])
    create index(:entries, [:publish])
    create index(:entries, [:sort])
    create index(:entries, [:release_date])
    create index(:entries, [:published_at])

  end
end
