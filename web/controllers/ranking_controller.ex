defmodule Extoon.RankingController do
  use Extoon.Web, :controller

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignLatest
  plug Extoon.Ctrl.Plug.AssignHottest
  plug Extoon.Ctrl.Plug.AssignRanking

  def index(conn, params) do
    render conn, "index.html"
  end
end
