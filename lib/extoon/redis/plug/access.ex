defmodule Extoon.Redis.Plug.Access do
  import Plug.Conn

  alias Extoon.Redis.Ranking

  def init(opts), do: opts
  def call(conn, opts) do
    Ranking.incr conn.params[opts[:key]]
    conn
  end
end
