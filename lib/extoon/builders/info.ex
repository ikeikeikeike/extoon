defmodule Extoon.Builders.Info do
  import Ecto.Query, only: [from: 2]
  import Extoon.Blank, only: [blank?: 1]

  alias Extoon.{Repo, Funcs}
  alias Extoon.{Entry, Maker, Label, Series, Category, Tag, Thumb}
  alias Extoon.Ecto.Q
  alias Extoon.Http.Client.Findinfo

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry,
        where: q.publish == false,
        order_by: q.updated_at,
        limit: 10

    # ExSentry.capture_exceptions fn ->
      queryable
      |> make_resource
      |> set_resource
      |> update
    # end
  end

  def make_resource(queryable) do
    queryable
    |> Repo.all
    |> Enum.map(fn entry ->
      case Findinfo.get(entry.title) do
        {:ok, res} ->
          {entry, res.body, %{}}

        {_, _res} ->
          skip entry
      end
    end)
    |> Enum.filter(& !!&1)
    |> Enum.map(fn {entry, items, params} ->
      with r when length(r) < 1 <- Findinfo.third(items),
           r when length(r) < 1 <- Findinfo.anime(items),
           r when length(r) < 1 <- Findinfo.doujin(items)
      do
        skip entry
      else
        r -> {entry, r, params}
      end
    end)
    |> Enum.filter(& !!&1)
  end

  def set_resource(resrces) when is_list(resrces) do
    resrces
    |> set_resource(:category)
    # |> set_resource(:content)  # TODO: Mostly `invalid byte sequence for encoding \"UTF8\": 0xa1"` happened.
    |> set_resource(:maker)
    |> set_resource(:image)
    |> set_resource(:tags)
    |> set_resource(:label)
    |> set_resource(:series)
    |> set_resource(:duration)
    |> set_resource(:release_date)
  end
  def set_resource(%{} = st, %Entry{} = entry, %{} = params, items, name) do
    # Creates or updates record inside of a model
    result =
      case Q.get_or_changeset(st, %{name: name}) do
        %Ecto.Changeset{} = changeset ->
          Repo.insert changeset
        model ->
          {:ok, model}
      end

    # Sets something inside of Entry model.
    case result do
      {:ok, model} ->
        {entry, items, Map.put(params, :"#{Funcs.thename(st)}_id", model.id)}
      _ ->
        nil
    end
  end
  # must be setting
  @labels Application.get_env(:extoon, :labels)
  def set_resource(resrces, :category) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      with {name, r} when length(r) < 1 <- {@labels[:third], Findinfo.third(items)},
           {name, r} when length(r) < 1 <- {@labels[:anime], Findinfo.anime(items)},
           {name, r} when length(r) < 1 <- {@labels[:doujin], Findinfo.doujin(items)}
      do
        skip entry
      else
        {name, r} ->
          set_resource %Category{}, entry, params, r, name
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :content) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.description(items)) do
        nil ->
          skip entry
        content ->
          {entry, items, Map.put(params, :content, content)}
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :maker) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.maker(items)) do
        nil ->
          skip entry
        name ->
          set_resource %Maker{}, entry, params, items, name
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :image) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case Findinfo.imageURL(items) do
        [] ->
          skip entry
        urls ->
          thumbs = Enum.map(urls, fn url ->
            %{src: Extoon.Image.Plug.Upload.make_plug!(url), assoc_id: entry.id}
          end)
          {entry, items, Map.put(params, :thumbs, thumbs)}
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :tags) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case Findinfo.genre(items) do
        nil ->
          {entry, items, params}
        genres ->
          tags = Enum.map(genres, & %{name: &1})
          {entry, items, Map.put(params, :tags, tags)}
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :label) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.label(items)) do
        nil ->
          {entry, items, params}
        name ->
          set_resource %Label{}, entry, params, items, name
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :series) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.series(items)) do
        nil ->
          {entry, items, params}
        name ->
          set_resource %Series{}, entry, params, items, name
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :duration) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.minutes(items)) do
        nil ->
          {entry, items, params}
        number ->
          {entry, items, Map.put(params, :duration, number)}
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :release_date) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items, params} ->
      case List.first(Findinfo.date(items)) do
        nil ->
          {entry, items, params}
        date ->
          {entry, items, Map.put(params, :release_date, Ecto.Date.cast!(date))}
      end
    end)
  end

  def update(resrces) when is_list(resrces) do
    result =
      Enum.map resrces, fn {entry, _items, params} ->
        changeset =
          Entry.info_changeset Repo.preload(entry, [:tags, :thumbs]), params

        Repo.transaction fn ->
          try do
            case Repo.update(changeset) do
              {:ok, _model} -> entry
              {_, err} -> ExSentry.capture_exception(err)
            end
          rescue
            err in Postgrex.Error ->
              Repo.rollback(entry)
              ExSentry.capture_exception(err)
          end
        end
      end

    Enum.each result, fn
      {:error, entry} ->
        skip entry
      _ ->
        nil
    end
  end

  defp skip(%Entry{} = st) do
    st
    |> Entry.changeset(%{updated_at: Ecto.DateTime.utc})
    |> Repo.update

    false
  end
end
