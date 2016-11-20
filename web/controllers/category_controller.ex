defmodule Extoon.CategoryController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignCategory

  def show(conn, %{"id" => id} = params) do
    entry = Repo.get!(Entry.query(Entry, :show), id)

    qs =
      from q in Entry,
      where: not is_nil(q.maker_id),
      preload: [:thumbs, :tags],
      limit: 4
    entries = Repo.all(qs)

    render conn, "show.html", entry: entry, entries: entries
  end

  def latest(conn, %{"name" => name} = params) do

  end

  def popular(conn, %{"name" => name} = params) do

  end

end
