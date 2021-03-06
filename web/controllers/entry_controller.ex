defmodule Extoon.EntryController do
  use Extoon.Web, :controller

  alias Extoon.{Repo, Entry, Category}

  import Ecto.Query, only: [from: 1, from: 2]

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignEntry
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignRanking
  plug Extoon.Ctrl.Plug.ParamsPaginator
  plug Extoon.Redis.Plug.Access, [key: "id"] when action in [:show]

  def index(conn, params) do
    entries =
      Entry.query(Entry, :index)
      |> Extoon.ESx.search(Entry.esquery(params))
      |> Extoon.ESx.paginate(params)

    render conn, "index.html", entries: entries
  end

  def release(conn, %{"alias" => alias} = params) do
    qs =
      from(Entry)
      |> Entry.query(:index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from [q, j] in qs,
      where: j.alias == ^alias,
      order_by: [desc: q.release_date]

    entries = Repo.paginate(qs, params)

    render conn, "index.html",
      entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def release(conn, params) do
    qs =
      from(Entry, order_by: [desc: :release_date])
      |> Entry.query(:index)
      |> Entry.published

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries
  end

  def prerelease(conn, params) do
    qs =
      from(Entry, order_by: [desc: :release_date])
      |> Entry.query(:index)
      |> Entry.prereleased

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries
  end

  def latest(conn, params) do
    qs =
      from(Entry, order_by: [desc: :published_at])
      |> Entry.query(:index)
      |> Entry.published

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries
  end

  def hottest(conn, params) do
    qs =
      from(Entry, order_by: [asc: :sort])
      |> Entry.query(:index)
      |> Entry.published

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries
  end

  def show(conn, %{"id" => id} = _params) do
    entry = Repo.get!(Entry.query(Entry, :show), id)
    entries = Enum.take_random(conn.assigns[:latest_entries], 4)

    render conn, "show.html", entry: entry, entries: entries
  end

  def suggest(conn, %{"q" => q}) do
    resources =
      ConCache.get_or_store :es, "entry:suggest:#{q}", fn ->
        word =
          String.split(q, ".")
          |> List.first

        from(Entry.query(Entry, :suggest))
        |> Extoon.ESx.search(Entry.essuggest(word))
        |> Extoon.ESx.records
        |> Enum.map(&Map.take &1, [
          :id, :title, :thumbs, :maker # , :label, :series
        ])
      end

    render(conn, "suggest.json", resources: resources)
  end
end
