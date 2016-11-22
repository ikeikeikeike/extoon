defmodule Extoon.HomeController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignCategory

  def index(conn, params) do
    entryqs = Entry.query(Entry, :index)
      # |> Entry.published

    # XXX: Temporary fix
    qs =
      from q in entryqs,
      where: not is_nil(q.maker_id),
      order_by: [desc: q.id],
      limit: 32

    entries = Repo.paginate(qs, params)

    esresult =
      Extoon.Entry
      |> ESx.Model.search(%{})
      |> ESx.Model.Response.records(entryqs)
      |> Scrivener.paginate(Scrivener.Config.new(params))

    render conn, "index.html", entries: esresult
  end
end
