defmodule Extoon.Ctrl.Plug.AssignPath do
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    Enum.with_index(conn.path_info)
    |> Enum.reduce(conn, fn {path, index}, acc ->
      assign acc, :"p#{index}", path
    end)
  end
end
