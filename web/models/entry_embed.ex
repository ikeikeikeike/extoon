defmodule Extoon.EntryEmbed do
  use Extoon.Web, :model
  use Extoon.Checks.Ecto

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


end
