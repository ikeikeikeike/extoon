defmodule Extoon.EntryEmbed do
  use Extoon.Web, :model

  schema "entries_embeds" do
    belongs_to :entry, Extoon.Entry
    field :code, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [:code])
    |> validate_required([:code])
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
