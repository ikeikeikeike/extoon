defmodule Extoon.CategoryController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignCategory

  def index(conn, %{"alias" => alias} = params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id) and j.alias == ^alias,
      order_by: [desc: q.id],
      limit: 32

    render conn, "index.html", category: Repo.get_by(Category, alias: alias), entries: Repo.all(qs)
  end

  def latest(conn, %{"alias" => alias} = params) do
    qs =
      from [q, j] in Entry.with_relation(Entry.query(Entry, :index), Category),
      where: not is_nil(q.maker_id) and j.alias == ^alias,
      order_by: [desc: q.id],
      limit: 32

    render conn, "latest.html", category: Repo.get_by(Category, alias: alias), entries: Repo.all(qs)
  end

  def popular(conn, %{"alias" => alias} = params) do

  end

end
