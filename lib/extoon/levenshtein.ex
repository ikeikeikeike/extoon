defmodule Extoon.Levenshtein do
  alias TheFuzz.Similarity.Levenshtein

  def compare(left, right) do
    left = prepare_comparing left
    right = prepare_comparing right

    Levenshtein.compare left, right
  end

  defp prepare_comparing(word) do
    word
    |> String.replace("　", "")
    |> String.split
    |> Enum.join("")
  end

end
