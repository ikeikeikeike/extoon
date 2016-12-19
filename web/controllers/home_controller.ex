defmodule Extoon.HomeController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignLatest
  plug Extoon.Ctrl.Plug.AssignHottest
  plug Extoon.Ctrl.Plug.AssignRanking
  plug Extoon.Ctrl.Plug.ParamsPaginator

  def index(conn, params) do
    order = Enum.random([:release_date, :sort, :id])
    qs =
      from(q in Entry, order_by: [desc: ^order])
      |> Entry.query(:index)
      |> Entry.published

    entries = Repo.paginate(qs, params)

    render conn, "index.html", entries: entries, order: orderkey(order)
  end

  defp orderkey(name) do
    case name do
      :release_date ->
        :release
      :sort ->
        :hottest
      :id ->
        :latest
    end
  end
end
