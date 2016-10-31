defmodule Extoon.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :maker_id, :integer

      add :url, :text
      add :title, :text
      add :content, :text
      add :seo_title, :text
      add :seo_content, :text
      add :published_at, :datetime

      timestamps()
    end
    create index(:entries, [:maker_id])

  end
end
