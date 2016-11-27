defmodule Extoon.HomeController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignCategory

  def index(conn, params) do
    entryqs =
      Entry.query(Entry, :index)
      |> Entry.published

    qs =
      from q in entryqs,
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries
  end
end
