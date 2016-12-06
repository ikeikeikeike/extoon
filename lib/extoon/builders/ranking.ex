defmodule Extoon.Builders.Ranking do
  alias Extoon.Redis.Ranking

  def run, do: run []
  def run([]) do
    Ranking.sum :all

    # Delete elements during days between 3 months ago to 2 months ago.
    now  = :calendar.local_time
    from = Timex.shift now, months: -3
    to   = Timex.shift now, months: -2

    Ranking.del from, to, :daily
    Ranking.del from, to, :weekly
    Ranking.del from, to, :monthly
  end

end
