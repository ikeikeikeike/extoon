defmodule Extoon.Http.Client.Findinfo do
  use HTTPoison.Base

  @endpoint Application.get_env(:extoon, :crawl)
  @agents Application.get_env(:extoon, :user_agents)

  def process_url(keyword) do
    @endpoint[:dmm][:findinfo] <> keyword
  end

  def process_request_headers(headers) do
    [{"User-Agent", @agents[:dmm]} | headers]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> get_in(["result", "items"])
  end

  def take(items, service, floor) when is_list(items) do
    items
    |> Enum.map(fn item ->
      take item, service, floor
    end)
    |> Enum.filter(fn item ->
      !! item
    end)
  end
  def take(%{"service_code" => service_code, "floor_code" => floor_code} = item, service, floor) do
    if service_code == "#{service}" && floor_code == "#{floor}", do: item, else: nil
  end

  def imageURL(item) do
    v = get_in item, ["imageURL", "large"]
    v = v || get_in item, ["imageURL", "list"]
    v = v || get_in item, ["imageURL", "small"]
    v
  end

  def minutes(item) do
    case Integer.parse(item["volume"]) do
      {n, _} -> n
      :error -> nil
    end
  end

  def genre(item) do
    v = get_in item, ["iteminfo", "genre"]
    v = v && Enum.map(v, & &1["name"])
    v
  end

  def series(item) do
    v = get_in item, ["iteminfo", "series"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

  def label(item) do
    v = get_in item, ["iteminfo", "label"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

  def maker(item) do
    v = get_in item, ["iteminfo", "maker"]
    v = v && Enum.map(v, & &1["name"]) |> List.first
    v
  end

end
