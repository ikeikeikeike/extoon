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
