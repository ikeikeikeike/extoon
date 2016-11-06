defmodule Extoon.Category do
  use Extoon.Web, :model

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
  end
end
