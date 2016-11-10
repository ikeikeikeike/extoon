defmodule Extoon.Http.Client.Scrape do
  use HTTPoison.Base
  import Extoon.Blank, only: [blank?: 1]

  @agents Application.get_env(:extoon, :user_agents)

  def process_request_headers(headers) do
    [{"User-Agent", @agents[:scrape]} | headers]
  end

  def description(:dmm, html) do
    html
    |> Floki.find(".mg-b20.lh4 p.mg-b20")
    |> Floki.text
  end

end
