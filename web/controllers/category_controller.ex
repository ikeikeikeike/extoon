defmodule Extoon.CategoryController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignEntry
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignRanking
  plug Extoon.Ctrl.Plug.ParamsPaginator

  def index(conn, %{"alias" => alias} = params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from [q, j] in qs,
      where: j.alias == ^alias,
      order_by: [desc: q.published_at],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "index.html",
      entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def index(conn, params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from([q, j] in qs, order_by: [desc: q.published_at], limit: 32)

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries, category: nil
  end

  def latest(conn, %{"alias" => alias} = params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from [q, j] in qs,
      where: j.alias == ^alias,
      order_by: [desc: q.published_at],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "index.html",
      entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def latest(conn, params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from([q, j] in qs, order_by: [desc: q.published_at], limit: 32)

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries, category: nil
  end

  def hottest(conn, %{"alias" => alias} = params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from [q, j] in qs,
      where: j.alias == ^alias,
      order_by: [asc: q.sort],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "hottest.html",
      entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def hottest(conn, params) do
    qs =
      Entry.query(Entry, :index)
      |> Entry.with_relation(Category)
      |> Entry.published
    qs =
      from([q, j] in qs, order_by: [asc: q.sort], limit: 32)

    entries = Repo.paginate(qs, params)

    render conn, "hottest.html", entries: entries, category: nil
  end


end
