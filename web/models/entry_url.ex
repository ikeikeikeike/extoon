defmodule Extoon.EntryUrl do
  use Extoon.Web, :model

  schema "entries_urls" do
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
end
