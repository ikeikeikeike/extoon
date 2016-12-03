defmodule Extoon.Ctrl.Plug.AssignHottest do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]

  alias Extoon.{Repo, Entry}

  def init(opts), do: opts
  def call(conn, _opts) do
    hottest_entries =
      ConCache.get_or_store :entries, "entries:assign_hottest", fn ->
        from(q in Entry, order_by: [desc: q.id], limit: 35)
        |> Entry.query(:index)
        |> Entry.published
        |> Repo.all
      end

    assign conn, :hottest_entries, hottest_entries
  end
end
