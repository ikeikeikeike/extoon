defmodule Extoon.Info do
  use Extoon.Web, :model

  schema "infos" do
    field :assoc_id, :integer
    field :info, {:array, :map}

    timestamps()
  end

  @requires ~w(info)a
  @options ~w(assoc_id)a

  @doc """
  Builds a changeset based on the `st` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, @requires, @options)
    |> validate_required(@requires)
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
