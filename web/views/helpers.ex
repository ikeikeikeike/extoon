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

  def latest_entries(%{} = st, where), do: latest_entries st.__struct__, where
  def latest_entries(mod, where) do
    key = "latest_entries:#{Funcs.thename mod}:#{inspect where}"

    ConCache.get_or_store :latest_entries, key, fn ->
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

  @def_keyword Application.get_env(:extoon, :categories)[:anime]
  def dms_attributes(assigns) do
    attrs =
      case assigns do
        %{entry: entry} ->
          attrs = ~w(
            data-keyword=#{entry.title}
            data-maker=#{entry.maker.name}
            data-category=#{entry.category.name}
          )

          attrs
          ++ [if(entry.label, do: "data-label=#{entry.label.name}")]
          ++ [if(entry.series, do: "data-series=#{entry.series.name}")]

        %{conn: %{params: %{"q" => q}}} ->
          ~w(data-keyword=#{q})

        %{category: %{name: name}} ->
          ~w(data-keyword=#{name})

        %{entries: entries} when not is_nil entries ->
          ~w(data-keyword=#{@def_keyword})

        _ ->
          []
      end

    attrs
    |> Enum.filter(& !!&1)
    |> Enum.join(" ")

  end

  def take_params(%Plug.Conn{} = conn, keys)
  when is_list(keys),
    do: take_params(conn, keys, %{})

  def take_params(%Plug.Conn{} = conn, keys, merge)
  when is_list(keys) and is_list(merge),
    do: take_params(conn, keys, Enum.into(merge, %{}))

  def take_params(%Plug.Conn{} = conn, keys, merge) do
    conn.params
    |> Map.take(keys)
    |> Map.merge(merge)
  end

  def take_hidden_field_tags(%Plug.Conn{} = conn, keys) when is_list(keys) do
    Enum.map take_params(conn, keys), fn{key, value} ->
      Tag.tag(:input, type: "hidden", id: key, name: key, value: value)
    end
  end

  def carried_params do
    ~w(page q maker label series category tag)
  end

  def search_value(conn) do
    [
      conn.params["q"],
      conn.params["tag"],
      conn.params["category"],
      conn.params["maker"],
      conn.params["label"],
      conn.params["series"],
    ]
    |> Enum.uniq
    |> Enum.join(" ")
    |> String.trim
  end

  def to_keylist(params) do
    Enum.reduce(params, [], fn {k, v}, kw ->
      if !is_atom(k), do: k = String.to_atom(k)
      Keyword.put(kw, k , v)
    end)
  end

  def to_qstring(params) do
    "?" <> URI.encode_query params
  end

end
