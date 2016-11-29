defmodule Extoon.Ecto.Q do
  alias Extoon.Repo

  import Extoon.Checks
  import Ecto.Query, only: [from: 1, from: 2]

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

  def exists?(queryable) do
    query =
      from(x in queryable, limit: 1)
      |> Ecto.Queryable.to_query

    case Repo.all(query) do
      [] -> false
      _  -> true
    end
  end

  def fuzzy_find(mod, name) when is_nil(name), do: fuzzy_find(mod, [])
  def fuzzy_find(mod, name) when is_bitstring(name) do
    case String.split(name, ~r(、|（|）)) do
      names when length(names) == 1 ->
        if model = Repo.get_by(mod, name: List.first(names)) do
          model
        else
          fuzzy_find mod, names
        end

      names when length(names)  > 1 ->
        fuzzy_find mod, names

      _ -> nil
    end
  end
  def fuzzy_find(_mod, []), do: nil
  def fuzzy_find(mod, [name|tail]) do
    case blank?(name) do
      true  -> fuzzy_find(mod, tail)
      false ->
        query =
          from q in mod,
            where: ilike(q.name, ^"%#{name}%"),
            limit: 1

        fuzzy_find(mod, [], Repo.one(query))
    end
  end
  def fuzzy_find(_mod, [], model), do: model

end
