defmodule Extoon.Tag do
  use Extoon.Web, :model

  schema "tags" do
    many_to_many :entries, Extoon.Entry, join_through: "entries_tags"

    field :name, :string
    field :kana, :string
    field :romaji, :string
    field :orig, :string
    field :gyou, :string

    field :outline, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
