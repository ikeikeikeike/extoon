defmodule Extoon.Builders.RebuildImage do
  import Extoon.Builders.Base

  alias Extoon.{Repo, Thumb}

  require Logger

  def perform do
    {"entries_thumbs", Thumb}
    |> Repo.all
    |> update
  end

  def update(thumbs) when is_list(thumbs) do
    result =
      Enum.map thumbs, fn thumb ->
        arc  = Arc.File.new Thumb.get_thumb(thumb)
        plug = %Plug.Upload{path: arc.path, filename: arc.file_name}

        changeset = Thumb.changeset thumb, %{src: plug}

        Repo.transaction fn ->
          try do
            case Repo.update(changeset) do
              {:ok, thumb} -> thumb
              {_, err} -> setback thumb, err
            end
          rescue
            err in Postgrex.Error ->
              setback thumb, err
          end
        end
      end

    Enum.each result, fn
      {:error, thumb} ->
        skip thumb, "final"
      _ ->
        nil
    end
  end

end
