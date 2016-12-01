defmodule Extoon.SuggestView do

  def render("suggest.json", %{names: names}) do
    Phoenix.View.render_many(names, __MODULE__, "typeahead.json", as: :name)
  end

  def render("typeahead.json", %{name: name}) do
    %{value: name, tokens: String.split(name)}
  end

end
