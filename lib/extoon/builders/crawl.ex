defmodule Extoon.Builders.Crawl do

  @endpoint Application.get_env(:extoon, :crawl)
  @agents Application.get_env(:extoon, :user_agents)

  def run, do: run []
  def run([]) do
    opts = [{"User-agent", @agents[:dmm]}, {"connect_timeout", 30}]
    case HTTPoison.get(@endpoint[:dmm], opts) do
      {:ok, r} ->
        Poison.decode r.body
      err ->
        err
    end
  end

end
