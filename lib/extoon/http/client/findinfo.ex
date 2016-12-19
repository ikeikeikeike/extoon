defmodule Extoon.Http.Client.Findinfo do
  use HTTPoison.Base
  import Extoon.Checks, only: [present?: 1]

  alias Extoon.Levenshtein
  alias Extoon.Http.Client.Scrape

  @agents Application.get_env(:extoon, :user_agents)
  @ignores Application.get_env(:extoon, :ignores)
  @endpoint Application.get_env(:extoon, :crawl)

  def process_url(keyword) do
    @endpoint[:dms][:findinfo] <> keyword
  end

  def process_request_headers(headers) do
    [{"User-Agent", @agents[:dms]} | headers]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> get_in(["result", "items"])
  end

  def better_choice(items, name), do: better_choice items, name, 2
  def better_choice(items, name, picks) when is_list(items) and is_integer(picks) do
    sorted =
      items
      |> Enum.map(fn item ->
         case Levenshtein.compare(name, item["title"]) do
           nil   -> nil
           score -> {score, item}
         end
      end)
      |> Enum.filter(& !!&1)
      |> Enum.sort(fn {left, _}, {right, _} ->
        left < right
      end)

    topscore = List.first sorted

    sorted
    |> Enum.filter(fn {score, _} ->
      elem(topscore, 0) == score
    end)
    |> Enum.map(& elem(&1, 1))
  end

  def take(items, both) when is_list(items), do: take items, both, nil
  def take(items, service, floor) when is_list(items) do
    items
    |> Enum.map(fn item ->
      take item, service, floor
    end)
    |> Enum.filter(fn item ->
      !! item
    end)
  end
  def take(%{"service_code" => service_code, "floor_code" => floor_code} = item, both, nil) do
    if service_code == "#{both}" || floor_code == "#{both}", do: item, else: nil
  end
  def take(%{"service_code" => service_code, "floor_code" => floor_code} = item, service, floor) do
    if service_code == "#{service}" && floor_code == "#{floor}", do: item, else: nil
  end
  def take(%{} = item, service, floor), do: nil

  def anime(items) do
    v = take items, :digital, :anime
    v = v ++ take items, :mono, :anime
    v
  end
  def doujin(items) do
    v = take items, :doujin, :digital_doujin
    v = v ++ take items, :mono, :doujin
    v
  end
  def third(items) do
    anime(items) ++ doujin(items)
    |> Enum.filter(fn item ->
      Enum.map(genre([item]), fn tag ->
        String.starts_with?(tag, ["3D", "3d"])
      end)
      |> Enum.any?
    end)
  end

  def imageURL(items) when is_list(items) do
    Enum.map(items, & imageURL &1)
    |> Enum.filter(& present? &1)
    |> Enum.uniq
  end
  def imageURL(item) do
    v = get_in item, ["imageURL", "large"]
    v = v || get_in item, ["imageURL", "list"]
    v = v || get_in item, ["imageURL", "small"]
    v
  end

  def affiURL(items) when is_list(items) do
    Enum.map(items, &affiURL/1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def affiURL(item) do
    item["affiliateURL"]
  end

  def affiURL(items, :sp) when is_list(items) do
    Enum.map(items, &affiURL(&1, :sp))
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def affiURL(item, :sp) do
    item["affiliateURLsp"]
  end

  def description(items) when is_list(items) do
    Enum.map(items, & description &1)
    |> Enum.filter(& present? &1)
    |> Enum.uniq
  end
  def description(item) do
    case Scrape.get(item["URL"]) do
      {:ok, r} ->
        Scrape.description :dms, r.body
      _ ->
        nil
    end
  end

  def date(items) when is_list(items) do
    Enum.map(items, & date &1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def date(item) do
    with spl when length(spl) > 0 <- String.split(item["date"] || ""),
         iso when not is_nil(iso) <- List.first(spl),
         {:ok, date}              <- Date.from_iso8601(iso) do
      date
    else
      nil
    end
  end

  def minutes(items) when is_list(items) do
    Enum.map(items, & minutes &1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def minutes(item) do
    case Integer.parse(item["volume"] || "") do
      {n, _} -> n
      :error -> nil
    end
  end

  @re_genre ~r/(#{Enum.join @ignores[:genre], "|"})/ui
  def genre(items) when is_list(items) do
    Enum.map(items, & genre &1)
    |> List.flatten
    |> Enum.filter(& !!&1)
    |> Enum.filter(fn name ->
      present?(name) && !(name =~ @re_genre)
    end)
    |> Enum.uniq
  end
  def genre(item) do
    v = get_in item, ["iteminfo", "genre"]
    v = v && Enum.map(v, & &1["name"])
    v
  end

  def series(items) when is_list(items) do
    Enum.map(items, & series &1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def series(item) do
    v = get_in item, ["iteminfo", "series"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

  def label(items) when is_list(items) do
    Enum.map(items, & label &1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def label(item) do
    v = get_in item, ["iteminfo", "label"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

  def maker(items) when is_list(items) do
    Enum.map(items, & maker &1)
    |> Enum.filter(& &1)
    |> Enum.uniq
  end
  def maker(item) do
    v = get_in item, ["iteminfo", "maker"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

end
