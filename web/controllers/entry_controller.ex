defmodule Extoon.EntryController do
  use Extoon.Web, :controller
  alias Extoon.{Repo, Entry, Category}
  alias Extoon.Ecto.Q

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignCategory

  def index(conn, params) do
    entryqs = Entry.query(Entry, :index)
      # |> Entry.published

    # XXX: Temporary fix
    # qs =
      # from q in entryqs,
      # where: not is_nil(q.maker_id),
      # order_by: [desc: q.id],
      # limit: 32

    # entries = Repo.paginate(qs, params)

    entries =
      entryqs
      |> Extoon.ESx.search(Entry.esquery(params))
      |> Extoon.ESx.paginate(params)

    render conn, "index.html", entries: entries
  end

  def show(conn, %{"id" => id} = params) do
    entry = Repo.get!(Entry.query(Entry, :show), id)

    qs =
      from q in Entry.published(Entry.query(Entry, :index)),
      order_by: [desc: q.id],
      limit: 4
    entries = Repo.all(qs)

    render conn, "show.html", entry: entry, entries: entries
  end
end
