defmodule Extoon.Builders.Crawl do
  import Ecto.Query, only: [from: 2]
  import Extoon.Blank, only: [blank?: 1]

  alias Extoon.Repo
  alias Extoon.Funcs
  alias Extoon.{Entry, Maker, Label, Series, Category, Tag, Thumb}
  alias Extoon.Http.Client.Findinfo

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry,
        where: q.publish == false,
        order_by: q.updated_at

    ExSentry.capture_exceptions fn ->
      queryable
      |> make_resource
      |> set_resource
      |> valid
      |> update
    end
  end

  def make_resource(queryable) do
    queryable
    |> Repo.all
    |> Enum.map(fn entry ->
      case Findinfo.get(entry.title) do
        {:ok, res} ->
          {entry, res.body}

        {_, _res} ->
          struct(entry, [updated_at: Ecto.DateTime.utc])
          |> Repo.update
          nil
      end
    end)
    |> Enum.filter(& !!&1)
    |> Enum.map(fn {entry, res} ->
      with items when length(items) > 0 <- Findinfo.third(res.body),
           items when length(items) > 0 <- Findinfo.anime(res.body),
           items when length(items) > 0 <- Findinfo.doujin(res.body)
      do
        {entry, items}
      else
        nil
      end
    end)
    |> Enum.filter(& !!&1)
  end

  def set_resource(resrces) when is_list(resrces) do
    resrces
    |> set_resource(:category)
    |> set_resource(:content)
    |> set_resource(:maker)
    |> set_resource(:image)
    |> set_resource(:tags)
    |> set_resource(:label)
    |> set_resource(:series)
    |> set_resource(:duration)
    |> set_resource(:release_date)
  end
  def set_resource(%{} = st, %Entry{} = entry, items, name) do
    # Creates or updates record inside of a model
    result =
      case get_or_changeset(st, %{name: name}) do
        st = model ->
          {:ok, model}

        changeset ->
          Repo.insert changeset
      end

    # Sets something inside of Entry model.
    case result do
      {:ok, model} ->
        {Map.put(entry, :"#{Funcs.thename(st)}_id", model.id), items}
      _ ->
        nil
    end
  end
  # must be setting
  @labels Application.get_env(:extoon, :labels)
  def set_resource(resrces, :category) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      with {name, items} when length(items) > 0 <- {@labels[:third], Findinfo.third(items)},
           {name, items} when length(items) > 0 <- {@labels[:anime], Findinfo.anime(items)},
           {name, items} when length(items) > 0 <- {@labels[:doujin], Findinfo.doujin(items)}
      do
        set_resource %Category{}, entry, items, name
      else
        nil
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :content) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.description(items)) do
        nil ->
          nil
        content ->
          {Map.put(entry, :content, content), items}
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :maker) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.maker(items)) do
        nil ->
          nil
        name ->
          set_resource %Maker{}, entry, items, name
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # must be setting
  def set_resource(resrces, :image) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case Findinfo.imageURL(items) do
        [] ->
          nil
        urls ->
          thumbs = Enum.map(urls, fn url ->
            %{src: Extoon.Image.Plug.Upload.make_plug!(url)}
          end)
          {Map.put(entry, :thumbs, thumbs), items}
      end
    end)
    |> Enum.filter(& !!&1)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :tags) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case Findinfo.genre(items) do
        nil ->
          {entry, items}
        genres ->
          tags = Enum.map(genres, & %{name: &1})
          {Map.put(entry, :tags, tags), items}
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :label) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.label(items)) do
        nil ->
          {entry, items}
        name ->
          set_resource %Label{}, entry, items, name
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :series) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.series(items)) do
        nil ->
          {entry, items}
        name ->
          set_resource %Series{}, entry, items, name
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :duration) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.minutes(items)) do
        nil ->
          {entry, items}
        number ->
          {Map.put(entry, :duration, number), items}
      end
    end)
  end
  # Be able to prefer Success either Failure.
  def set_resource(resrces, :release_date) when is_list(resrces) do
    Enum.map(resrces, fn {entry, items} ->
      case List.first(Findinfo.date(items)) do
        nil ->
          {entry, items}
        date ->
          {Map.put(entry, :release_date, Ecto.Date.cast!(date)), items}
      end
    end)
  end

  def valid(resrces) when is_list(resrces) do
  end

  def update(resrces) when is_list(resrces) do
    Enum.each resrces, fn {entry, _items} ->
      Repo.transaction fn ->
        case Repo.update(entry) do
          {:ok, _model} -> nil
          {_, err} -> ExSentry.capture_exception(err)
        end
      end
    end
  end

  def get_or_changeset(%{} = st, queryables) when is_list(queryables),
    do: Enum.map queryables, &get_or_changeset(st, &1)
  def get_or_changeset(%{} = st, queryable) do
    case Repo.get_by(st, queryable) do
      nil ->
        apply st, :changeset, [st.__struct__, queryable]
      model ->
        model
    end
  end
end
