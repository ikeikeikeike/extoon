defmodule Extoon.EntryView do
  use Extoon.Web, :view

  alias Extoon.Thumb
  alias Extoon.MyHelpers

  def page_title(:show, assigns) do
    title = truncate(assigns.entry.title, length: 100)
    title <> " - " <> gettext("Default Page Title")
  end

  def page_title(:release, assigns) do
    gettext("Release Default Page Title") <> " - " <> gettext("Default Page Title")
  end

  def page_title(:prerelease, assigns) do
    gettext("Prerelease Default Page Title") <> " - " <> gettext("Default Page Title")
  end

  def page_title(:hottest, assigns) do
    gettext("Hottest Default Page Title") <> " - " <> gettext("Default Page Title")
  end

  def page_title(:latest, assigns) do
    gettext("Latest Default Page Title") <> " - " <> gettext("Default Page Title")
  end

  def page_description(:show, assigns) do
    after_description =
      (assigns[:entries] || [])
      |> Enum.map(fn entry -> entry.title end)
      |> Enum.join(", ")

    gettext("Content Explain") <> ": " <>
    Enum.join([
      truncate(extract(:content, assigns.entry.content), length: 200),
      truncate(after_description, length: 200),
    ], ", ")
  end

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

  def what(conn) do
    case MyHelpers.what(conn, :base) do
      "entry_release" ->
        :release
      "entry_prerelease" ->
        :prerelease
      "entry_hottest" ->
        :hottest
      "entry_latest" ->
        :latest
      "entry_index" ->
        :search
      _ ->
        :none
    end
  end


end
