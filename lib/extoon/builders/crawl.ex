defmodule Extoon.Builders.Crawl do
  import Ecto.Query, only: [from: 2]

  alias Extoon.Repo
  alias Extoon.Entry
  alias Extoon.Http.Client.Findinfo

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry,
        where: q.publish == false,
        order_by: q.updated_at

    queryable
    |> make_resource
    |> update
  end

  def make_resource(queryable) do
    queryable
    |> Repo.all
    |> Enum.map(fn entry ->
      case Findinfo.get(entry.title) do
        {:ok, res} ->
          {entry, res}

        {_, _res} ->
          struct(entry, [updated_at: Ecto.DateTime.utc])
          |> Repo.update
          nil
      end
    end)
    |> Enum.filter(fn resrc ->
      !! resrc
    end)
  end

  def update(resrces) when is_list(resrces) do
    update :maker, resrces
    update :label, resrces
    update :series, resrces
    update :category, resrces
  end
  def update(:maker, resrces) when is_list(resrces)  do

  end
  def update(:label, resrces) when is_list(resrces)  do

  end
  def update(:series, resrces) when is_list(resrces)  do

  end
  def update(:category, resrces) when is_list(resrces)  do

  end

end
