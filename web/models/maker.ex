defmodule Extoon.Maker do
  use Extoon.Web, :model

  schema "makers" do
    has_many :entries, Extoon.Entry

    field :identifier, :integer
    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string
    field :url, :string
    field :outline, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [:name], [:identifier, :alias, :kana, :romaji, :gyou, :url, :outline])
    |> validate_required([:name])
  end
end
