defmodule Extoon.Ecto.Q do
  alias Extoon.Repo

  def get_or_changeset(%{} = st, conditions) when is_list(conditions),
    do: Enum.map conditions, &get_or_changeset(st, &1)
  def get_or_changeset(%{} = st, condition) do
    case Repo.get_by(st.__struct__, condition) do
      nil ->
        apply st.__struct__, :changeset, [st, condition]
      model ->
        model
    end
  end
  def get_or_changeset(mod, condition),
    do: get_or_changeset struct(mod), condition

end
