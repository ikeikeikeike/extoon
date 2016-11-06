defmodule Extoon.EntryEmbed do
  use Extoon.Web, :model

  schema "entries_embeds" do
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
