defmodule Extoon.Builders.Publish do
  import Extoon.Builders.Base
  import Ecto.Query, only: [from: 2]

  alias Extoon.{Repo, Entry}

  require Logger

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry.reserved(Entry.query(Entry, :doc)),
        order_by: q.updated_at,
        limit: 21

    publish queryable
  end

  defp publish(queryable) do
    result =
      Enum.map Repo.all(queryable), fn entry ->
        changeset = Entry.publish_changeset entry

        Repo.transaction fn ->
          try do
            with {:ok, entry} <- Repo.update(changeset),
                 {:ok, resp}  <- Extoon.ESx.index_document(entry) do
              IO.inspect "ok: #{inspect [entry.id, entry.publish]}"
              resp
            else
              {_, err} ->
                IO.inspect "setback: #{inspect [entry.id, entry.publish]}"
                setback entry, err
            end
          rescue
            err in Postgrex.Error ->
              setback entry, err
          end
        end
      end

    Enum.map(result, fn
      {:error, entry} ->
        skip entry, "final"
      _ ->
        nil
    end)
    |> Enum.filter(&is_nil/1)
    |> length
  end

end
