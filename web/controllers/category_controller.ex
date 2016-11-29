defmodule Extoon.CategoryController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignCategory

  def index(conn, %{"alias" => alias} = params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id) and j.alias == ^alias,
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def index(conn, params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id),
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries, category: nil
  end

  def latest(conn, %{"alias" => alias} = params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id) and j.alias == ^alias,
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "latest.html", entries: entries, category: Repo.get_by(Category, alias: alias)
  end

  def latest(conn, params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id),
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "latest.html", entries: entries, category: nil
  end

  def popular(conn, %{"alias" => alias} = params) do

  end

end
