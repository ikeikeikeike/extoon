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
end
