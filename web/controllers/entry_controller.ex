defmodule Extoon.EntryController do
  use Extoon.Web, :controller
  alias Extoon.Repo
  alias Extoon.{Entry, Category}

  def show(conn, %{"id" => id} = params) do
    entry = Repo.get!(Entry, id) |> Repo.preload([:thumbs, :tags])

    qs =
      from q in Entry,
      where: not is_nil(q.maker_id),
      preload: [:thumbs, :tags],
      limit: 4
    entries = Repo.all(qs)

    qs = from q in Category, order_by: q.id
    categories = Repo.all(qs)

    render conn, "show.html", entry: entry, entries: entries, categories: categories
  end
end
