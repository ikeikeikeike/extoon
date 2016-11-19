defmodule Extoon.HomeController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  def index(conn, _params) do
    qs = Entry.query(Entry, :index)
      # |> Entry.published
    # XXX: Temporary fix
    qs =
      from q in qs,
      where: not is_nil(q.maker_id),
      limit: 32

    entries = Repo.all(qs)

    qs = from q in Category, order_by: q.id
    categories = Repo.all(qs)

    render conn, "index.html", entries: entries, categories: categories
  end
end
