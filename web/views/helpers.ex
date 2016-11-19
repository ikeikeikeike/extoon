defmodule Extoon.MyHelpers do
  use Phoenix.HTML

  import Ecto.Query, only: [from: 1, from: 2]

  alias Extoon.Repo
  alias Extoon.{Entry,Thumb}
  alias Extoon.Funcs

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

  def nearly_entries(%{maker: maker, label: label, series: series} = entry) do
    lentries = Map.get label || %{}, :entries, []
    sentries = Map.get series || %{}, :entries, []

    entries =
      [lentries, maker.entries, sentries]
      |> List.flatten
      |> Enum.uniq_by(& &1.id)
      |> Enum.reverse

    case entries do
      entries when length(entries) > 5 ->
        entries
      entries ->
        entries ++ Repo.all(Entry.categories(entry.id))
    end
  end

  def new_categories(%{} = st, where), do: new_categories st.__struct__, where
  def new_categories(mod, where) do
    key = "new_entries:#{Funcs.thename mod}:#{inspect where}"

    ConCache.get_or_store :new_entries, key, fn ->
      qs =
        from(q in Entry, order_by: [desc: q.id], limit: 4)
        |> Entry.query(:index)
        |> Entry.with_relation(mod)
      # |> Entry.released

      from([q, j] in qs, where: ^where)
      |> Repo.all
    end
  end

  def popular_entries do

  end

end
