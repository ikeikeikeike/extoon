defmodule Extoon.Builders.Crawl do
  import Ecto.Query

  alias Extoon.Repo
  alias Extoon.Entry
  alias Extoon.Http.Client.Findinfo

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry,
        where: q.publish == false,
        order_by: q.updated_at

    resrc = make_resource queryable

  end

  def update_category do

  end
  def update_maker do

  end
  def update_label do

  end
  def update_series do$

  end

  def make_resource(queryable) do
    queryable
    |> Repo.all
    |> Enum.map(fn entry ->
      case Findinfo.get(entry.title) do
        {:ok, item} ->
          {entry, item}

        {_, item} ->
          struct(entry, [updated_at: Ecto.DateTime.utc])
          |> Repo.update
          {:error, entry, item}
      end
    end)
    |> Enum.filter(fn item ->
      case item do
        {:error, _, _} ->
          false
        _ ->
          true
      end
    end)
  end
end
