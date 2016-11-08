defmodule Extoon.Funcs do
  def thename(%{} = st) do
    st.__struct__
    |> to_string
    |> String.split(".")
    |> List.last
    |> String.downcase
  end
end
