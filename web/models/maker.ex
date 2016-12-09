defmodule Extoon.Maker do
  use Extoon.Web, :model

  schema "makers" do
    has_many :entries, Extoon.Entry

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
    |> cast(params, [:name], [:alias, :kana, :romaji, :gyou, :url, :outline])
    |> validate_required([:name])
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
