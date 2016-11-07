defmodule Extoon.Http.Client.Plugupload do
  use HTTPoison.Base

  @agents Application.get_env(:extoon, :user_agents)

  def process_request_headers(headers) do
    [{"User-Agent", @agents[:image]} | headers]
  end

end
