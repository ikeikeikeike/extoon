defmodule Extoon.Tag do
  use Extoon.Web, :model

  schema "tags" do
    many_to_many :entries, Extoon.Entry, join_through: "entries_tags"

    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string

    field :outline, :string

    timestamps()
  end

  @requires ~w(name)a
  @options ~w(alias kana romaji gyou outline)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @requires, @options)
    |> validate_required(@requires)
    |> unique_constraint(:name)
  end

  defimpl Extoon.Checks, for: __MODULE__ do
    alias Extoon.Checks

    def present?(%{id: id}) do
      Checks.present?(id)
    end
    def present?(_) do
      false
    end
    def blank?(data) do
      not Checks.present?(data)
    end
  end

end
