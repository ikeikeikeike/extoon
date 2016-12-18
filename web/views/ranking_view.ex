defmodule Extoon.RankingView do
  use Extoon.Web, :view

  def page_title(:index, assigns) do
    gettext("Ranking Page Title") <> " - " <> gettext("Default Page Title")
  end

  def page_description(:index, assigns) do
    after_description =
      [
        assigns.c1.entries,
        assigns.c2.entries,
        assigns.c3.entries
      ]
      |> Enum.random
      |> Enum.map(fn entry -> entry.title end)
      |> Enum.join(", ")

    gettext("Movie Titles") <> ": " <>
    Enum.join([
      truncate(after_description, length: 500),
    ], ", ")
  end

end
