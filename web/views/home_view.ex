defmodule Extoon.HomeView do
  use Extoon.Web, :view

  def page_title(_, _), do: gettext "Default Page Title"
  def page_description(_, _), do: gettext "Default Page Description"

end
