defmodule Extoon.EntryUrl do
  use Extoon.Web, :model

  schema "entries_urls" do
    belongs_to :entry, Extoon.Entry
    field :url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [:url])
    |> validate_required([:url])
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
