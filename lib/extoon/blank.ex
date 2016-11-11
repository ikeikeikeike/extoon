defprotocol Extoon.Checks do
  @fallback_to_any true

  def blank?(data)
  def present?(data)
end

defimpl Extoon.Checks, for: Integer do
  alias Extoon.Checks
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: String do
  alias Extoon.Checks
  def blank?(''),     do: true
  def blank?(' '),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: BitString do
  alias Extoon.Checks
  def blank?(""),     do: true
  def blank?(" "),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: List do
  alias Extoon.Checks
  def blank?([]),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: Tuple do
  alias Extoon.Checks
  def blank?({}),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: Map do
  alias Extoon.Checks
  def blank?(%{}),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: Atom do
  alias Extoon.Checks
  def blank?(false),  do: true
  def blank?(nil),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: MapSet do
  alias Extoon.Checks
  def blank?(data),   do: Enum.empty?(data)
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: Ecto.Date do
  alias Extoon.Checks
  def blank?(%Ecto.Date{year: 0, month: 0, day: 0}), do: true
  def blank?(%Ecto.Date{year: 1, month: 1, day: 1}), do: true
  def blank?(_), do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Extoon.Checks, for: Any do
  def blank?(_),      do: false
  def present?(_),    do: false
end
