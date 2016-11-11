defmodule Extoon.Info do
  use Extoon.Web, :model

  schema "infos" do
    field :assoc_id, :integer
    field :info, :map

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

end
