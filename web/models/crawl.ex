defmodule Extoon.Crawl do
  use Extoon.Web, :model

  schema "crawls" do
    field :state, :string
    field :name, :string
    field :info, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state, :name, :info])
    |> validate_required([:state, :name, :info])
  end
end
