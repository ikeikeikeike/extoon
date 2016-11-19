defmodule Extoon.Funcs do
  def thename(%{} = st), do: thename st.__struct__
  def thename(mod) do
    mod
    |> to_string
    |> String.split(".")
    |> List.last
    |> String.downcase
  end
end
