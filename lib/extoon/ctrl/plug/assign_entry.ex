defmodule Extoon.Ctrl.Plug.AssignEntry do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]

  alias Extoon.{Repo, Entry}

  def init(opts), do: opts
  def call(conn, _opts) do
    conn
    |> assign(:hottest_entries, hottest())
    |> assign(:latest_entries, latest())
    |> assign(:release_entries, release())
    |> assign(:prerelease_entries, prerelease())
  end

  defp hottest do
    ConCache.get_or_store :entries, "entries:assign_hottest", fn ->
      from(q in Entry, order_by: [asc: q.sort], limit: 35)
      |> Entry.query(:index)
      |> Entry.published
      |> Repo.all
    end
  end

  defp latest do
    ConCache.get_or_store :entries, "entries:assign_latest", fn ->
      from(q in Entry, order_by: [desc: q.id], limit: 35)
      |> Entry.query(:index)
      |> Entry.published
      |> Repo.all
    end
  end

  defp release do
    ConCache.get_or_store :entries, "entries:assign_release", fn ->
      from(q in Entry, order_by: [desc: q.release_date], limit: 35)
      |> Entry.query(:index)
      |> Entry.published
      |> Repo.all
    end
  end

  defp prerelease do
    ConCache.get_or_store :entries, "entries:assign_prerelease", fn ->
      from(q in Entry, order_by: [desc: q.release_date], limit: 35)
      |> Entry.query(:index)
      |> Entry.prereleased
      |> Repo.all
    end
  end

end
