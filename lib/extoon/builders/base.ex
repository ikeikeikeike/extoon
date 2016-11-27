defmodule Extoon.Builders.Base do
  require Logger
  alias Extoon.Repo

  def setback(st, err) do
    Logger.warn "Setback\nErr:#{inspect err}\nSt:#{inspect st}"

    Repo.rollback(st)
    ExSentry.capture_exception(err)
  end

  def skip(%{} = st), do: skip st, ""
  def skip(%{} = st, msg) do
    Logger.warn "Skip\nMsg:#{inspect msg}\nSt:#{inspect st}"

    st
    |> st.__struct__.changeset(%{updated_at: Ecto.DateTime.utc})
    |> Repo.update

    false
  end

end
