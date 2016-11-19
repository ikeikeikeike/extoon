defmodule Extoon.MyHelpers do
  use Phoenix.HTML

  alias Extoon.Thumb

  def thumb(thumbs) do
    if thumb = List.first(thumbs), do: Thumb.get_thumb(thumb), else: nil
  end

  def render_with(module, template, assigns) do
    {_, _, fnames} = module.__templates__
    if template in fnames do
      module.render template, assigns
    else
      render_with template, assigns
    end
  end

  def render_with(template, assigns) do
    {layout, _} = assigns.conn.private.phoenix_layout
    layout.render template, assigns
  end

end
