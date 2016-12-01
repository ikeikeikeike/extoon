defmodule Extoon.EntryView do
  use Extoon.Web, :view

  alias Extoon.Thumb

  def render("suggest.json", %{resources: resources}) do
    Phoenix.View.render_many(resources, __MODULE__, "typeahead.json", as: :resource)
  end

  def render("typeahead.json", %{resource: resource}) do
    id    = Map.get(resource, :id)
    title = Map.get(resource, :title)
    thumb = get_in resource, [:thumbs, Access.at(0)]
    thumb = if thumb, do: Thumb.get_thumb(thumb), else: ""

    %{
      id:     id,
      value:  title,
      thumb:  thumb,
      maker:  get_in(resource, [:maker, Access.key(:name)]),
      # label: get_in(resource, [:label, Access.key(:name)]),
      # series: get_in(resource, [:series, Access.key(:name)]),
      tokens: String.split(title),
    }
  end


end
