defmodule Extoon.Crawl do
  use Extoon.Web, :model

  schema "crawls" do
    field :state, :string
    field :name, :string
    field :info, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [:state, :name, :info])
    |> validate_required([:state, :name, :info])
  end
end
