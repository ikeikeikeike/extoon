defmodule Extoon.Ctrl.Plug.AssignRanking do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]
  import Extoon.Checks, only: [blank?: 1]

  alias Extoon.{Repo, Entry}
  alias Extoon.Redis.Ranking

  def init(opts), do: opts
  def call(conn, _opts) do
    ids = Ranking.top :weekly, 0, 100
    ids =
      if blank?(ids) do
        Ranking.sum :weekly  # TODO: batch
        Ranking.top :weekly, 0, 100
      else
        ids
      end

    key =
      inspect(ids)
      |> :erlang.md5
      |> Base.encode16(case: :lower)

    ranked_entries =
      ConCache.get_or_store :entries, "ranking:all:#{key}", fn ->
        ranking =
          from(q in Entry, where: q.id in ^ids)
          |> Entry.query(:index)
          # |> Entry.published  # TODO: bugfix
          |> Repo.all

        Enum.map(ids, fn id ->
          case Enum.filter(ranking, & id == &1.id) do
            [elm] -> elm
            _     -> nil
          end
        end)
        |> Enum.filter(& not is_nil &1)
      end

    assign conn, :ranked_entries, ranked_entries
  end
end
