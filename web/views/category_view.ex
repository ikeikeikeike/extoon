defmodule Extoon.CategoryView do
  use Extoon.Web, :view

  @extra Application.get_env(:extoon, :categories)[:extra]

  def page_title(:hottest, assigns) do
    gettext("%{cname} and Hottest Page Title", cname: category_title(assigns.conn)) <>
    " - " <>
    gettext("Default Page Title")
  end

  def page_title(:latest, assigns) do
    gettext("%{cname} and Latest Page Title", cname: category_title(assigns.conn)) <>
    " - " <>
    gettext("Default Page Title")
  end

  def page_title(:index, assigns) do
    gettext("%{cname} and Index Page Title", cname: category_title(assigns.conn)) <>
    " - " <>
    gettext("Default Page Title")
  end

  defp category_title(conn) do
    anime = @extra[:anime][:alias]
    third = @extra[:third][:alias]
    doujin = @extra[:doujin][:alias]

    case conn.path_info |> List.last do
      ^anime  ->
        gettext("Anime Default Page Title")
      ^third  ->
        gettext("Third Default Page Title")
      ^doujin ->
        gettext("Doujin Default Page Title")
      _       ->
        ""
    end
  end

end
