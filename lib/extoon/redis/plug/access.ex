defmodule Extoon.Redis.Plug.Access do
  import Plug.Conn
  import Extoon.Checks, only: [present?: 1]

  alias Extoon.Redis.Ranking

  def init(opts), do: opts
  def call(conn, opts) do
    id = conn.params[opts[:key]]

    if present?(id), do: Ranking.incr id

    conn
  end
end
