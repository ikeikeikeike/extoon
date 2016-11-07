defmodule Extoon.Builders.Crawl do
  import Ecto.Query, only: [from: 2]

  alias Extoon.Repo
  alias Extoon.Entry
  alias Extoon.Category
  alias Extoon.Http.Client.Findinfo

  def run, do: run []
  def run([]) do
    queryable =
      from q in Entry,
        where: q.publish == false,
        order_by: q.updated_at

    queryable
    |> make_resource
    |> set_resource
    |> valid
    |> update
  end

  def make_resource(queryable) do
    queryable
    |> Repo.all
    |> Enum.map(fn entry ->
      case Findinfo.get(entry.title) do
        {:ok, res} ->
          {entry, res}

        {_, _res} ->
          struct(entry, [updated_at: Ecto.DateTime.utc])
          |> Repo.update
          nil
      end
    end)
    |> Enum.filter(fn resrc ->
      !! resrc
    end)
  end

  def set_resource(resrces) when is_list(resrces) do
    set_resource :category, resrces
    set_resource :maker, resrces
    set_resource :label, resrces
    set_resource :series, resrces
    set_resource :image, resrces
  end
  @labels Application.get_env(:extoon, :labels)
  def set_resource(:category, resrces) when is_list(resrces) do
    Enum.map(resrces, fn {entry, res} ->
      with {name, items} when length(items) > 0 <- {@labels[:third], Findinfo.third(res.body)},
           {name, items} when length(items) > 0 <- {@labels[:anime], Findinfo.anime(res.body)},
           {name, items} when length(items) > 0 <- {@labels[:doujin], Findinfo.doujin(res.body)} do

        result =
          case get_or_changeset(%Category{}, %{name: name}) do
            %Category{} = cate ->
              {:ok, cate}

            changeset ->
              Repo.insert changeset
          end

        case result do
          {:ok, cate} ->
            {%{entry | category_id: cate.id}, items}

          _ ->
            nil
        end
      else
        nil
      end
    end)
    |> Enum.filter(& !!&1)
  end
  def set_resource(:maker, resrces) when is_list(resrces) do
    Enum.map resrces, fn {entry, res} ->
      Findinfo.maker(res.body)
    end
  end
  def set_resource(:label, resrces) when is_list(resrces) do
    Findinfo.label

  end
  def set_resource(:series, resrces) when is_list(resrces) do
    Findinfo.series

  end
  def set_resource(:image, resrces) when is_list(resrces) do
    Findinfo.imageURL

  end

  def valid(resrces) when is_list(resrces) do

  end

  def update(resrces) when is_list(resrces) do

  end

  def get_or_changeset(mod, queryables) when is_list(queryables),
    do: Enum.map queryables, &get_or_changeset(mod, &1)
  def get_or_changeset(mod, queryable) do
    case Repo.get_by(mod, queryable) do
      nil ->
        apply mod, :changeset, [mod.__struct__, queryable]
      model ->
        model
    end
  end

end
