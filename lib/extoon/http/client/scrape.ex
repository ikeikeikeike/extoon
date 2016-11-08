defmodule Extoon.Http.Client.Scrape do
  use HTTPoison.Base
  import Extoon.Blank, only: [blank?: 1]

  @agents Application.get_env(:extoon, :user_agents)

  def process_request_headers(headers) do
    [{"User-Agent", @agents[:scrape]} | headers]
  end

  def description(:dmm, html) do
    html
    |> Floki.find("")
    |> Floki.text
  end

end
