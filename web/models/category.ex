defmodule Extoon.Category do
  use Extoon.Web, :model
  use Extoon.Checks.Ecto

  schema "categories" do
    has_many :entries, Extoon.Entry

    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [:name], [:alias, :kana, :romaji, :gyou])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

end
