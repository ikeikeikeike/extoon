defmodule Extoon.Checks.Ecto do
  defmacro __using__(_) do
    quote do
      defimpl Extoon.Checks, for: __MODULE__ do
        alias Extoon.Checks

        def present?(%{id: id}) do
          Checks.present?(id)
        end
        def present?(_) do
          false
        end
        def blank?(data) do
          not Checks.present?(data)
        end
      end
    end
  end
end
