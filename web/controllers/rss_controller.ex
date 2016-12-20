defmodule Extoon.RssController do
  use Extoon.Web, :controller
  alias Extoon.Entry

  def index(conn, _params) do
    entries =
      from(q in Entry, order_by: [desc: q.published_at], limit: 50)
      |> Entry.query(:rss)
      |> Entry.published
      |> Repo.all

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("rdf.xml", entries: entries)
  end

end
