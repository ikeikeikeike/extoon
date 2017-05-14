defmodule Extoon.HomeController do
  use Extoon.Web, :controller

  alias Extoon.{Repo, Entry, MyHelpers}

  plug Extoon.Ctrl.Plug.AssignPath
  plug Extoon.Ctrl.Plug.AssignEntry
  plug Extoon.Ctrl.Plug.AssignCategory
  plug Extoon.Ctrl.Plug.AssignRanking
  plug Extoon.Ctrl.Plug.ParamsPaginator

  def index(conn, params) do
    order = Enum.random([
      [desc: :release_date],
      [asc: :sort],
      [desc: :published_at]
    ])

    {currently_path, order_key} = orderkey(conn, order)
    qs =
      from(q in Entry, order_by: ^order)
      |> Entry.query(:index)
      |> Entry.published

    entries = Repo.paginate(qs, params)

    render conn, "index.html",
      entries: entries,
      order_key: order_key,
      currently_path: currently_path
  end

  defp orderkey(conn, name) do
    carried_locale = MyHelpers.take_params(conn, MyHelpers.carried_locales)
    case name do
      [desc: :release_date] ->
        {entry_path(conn, :release, "", carried_locale), :release}
      [asc: :sort] ->
        {entry_path(conn, :hottest, carried_locale), :hottest}
      [desc: :published_at] ->
        {entry_path(conn, :latest, carried_locale), :latest}
    end
  end
end
