defmodule Extoon.MyHelpers do
  use Phoenix.HTML

  alias Extoon.Thumb

  def thumb(thumbs) do
    if length(thumbs) > 0, do: Thumb.get_thumb(List.first(thumbs)), else: nil
  end

end
