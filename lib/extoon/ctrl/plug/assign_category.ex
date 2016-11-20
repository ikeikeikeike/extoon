defmodule Extoon.Ctrl.Plug.AssignCategory do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]

  alias Extoon.{Repo,Category}

  def init(opts), do: opts
  def call(conn, _opts) do
    categories =
      ConCache.get_or_store :categories, "categories:asc", fn ->
        from(q in Category, order_by: q.id)
        |> Repo.all
      end

    assign conn, :categories, categories
  end
end
