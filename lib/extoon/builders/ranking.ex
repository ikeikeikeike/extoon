defmodule Extoon.Builders.Ranking do
  def run, do: run []
  def run([]) do
    # TODO: delete previous record from redis

    Extoon.Redis.Ranking.sum :all
  end

end
