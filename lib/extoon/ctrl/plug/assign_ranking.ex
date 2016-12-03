defmodule Extoon.Ctrl.Plug.AssignRanking do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]
  import Extoon.Checks, only: [blank?: 1]

  alias Extoon.{Repo, Entry}

  def init(opts), do: opts
  def call(conn, _opts) do
    ids = Extoon.Redis.Ranking.top :weekly, 0, 100
    ids =
      if blank?(ids) do
        Extoon.Redis.Ranking.sum :weekly  # TODO: batch
        Extoon.Redis.Ranking.top :weekly, 0, 100
      else
        ids
      end

    ranked_entries =
      ConCache.get_or_store :entries, "ranking:all:#{inspect ids}", fn ->
        ranking =
          from(q in Entry, where: q.id in ^ids)
          |> Entry.query(:index)
          |> Entry.published
          |> Repo.all

        Enum.map ids, fn id ->
          [elm] = Enum.filter ranking, & id == &1.id
           elm
        end
      end

    assign conn, :ranked_entries, ranked_entries
  end
end
