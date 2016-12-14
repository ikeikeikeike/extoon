defmodule Extoon.RankingController do
  use Extoon.Web, :controller

  alias Extoon.Entry

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignLatest
  plug Extoon.Ctrl.Plug.AssignHottest
  plug Extoon.Ctrl.Plug.AssignRanking

  def index(conn, params) do
    qs =
      from(Entry, order_by: [asc: :sort])
      |> Entry.query(:index)
      |> Entry.published

    c1 = Repo.paginate(from(q in qs, where: q.category_id == 1), %{page: 1, page_size: 50})
    c2 = Repo.paginate(from(q in qs, where: q.category_id == 2), %{page: 1, page_size: 50})
    c3 = Repo.paginate(from(q in qs, where: q.category_id == 3), %{page: 1, page_size: 50})

    render conn, "index.html", c1: c1, c2: c2, c3: c3
  end
end
