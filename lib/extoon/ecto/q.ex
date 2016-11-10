defmodule Extoon.Ecto.Q do
  alias Extoon.Repo

  def get_or_changeset(%{} = st, queryables) when is_list(queryables),
    do: Enum.map queryables, &get_or_changeset(st, &1)
  def get_or_changeset(%{} = st, queryable) do
    case Repo.get_by(st.__struct__, queryable) do
      nil ->
        apply st.__struct__, :changeset, [st, queryable]
      model ->
        model
    end
  end

end
