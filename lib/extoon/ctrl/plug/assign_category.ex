defmodule Extoon.Ctrl.Plug.AssignCategory do
  import Plug.Conn
  import Ecto.Query, only: [from: 1, from: 2]

  alias Extoon.{Repo, Entry, Category, Funcs}

  def init(opts), do: opts
  def call(conn, _opts) do
    categories =
      ConCache.get_or_store :categories, "categories:asc", fn ->
        from(q in Category, order_by: q.id)
        |> Repo.all
      end

    conn =
      Enum.reduce categories, conn, fn c, acc ->
        acc
        |> assign(:"latest_#{c.alias}_entries", latest_entries(c.id))
        |> assign(:"hottest_#{c.alias}_entries", hottest_entries(c.id))
        |> assign(:"ranked_#{c.alias}_entries", ranked_entries(c.id))
        |> assign(:"release_#{c.alias}_entries", release_entries(c.id))
        |> assign(:"prerelease_#{c.alias}_entries", prerelease_entries(c.id))
      end

    conn
    |> assign(:categories, categories)
  end

  defp latest_entries(category_id) do
    key = "entries:latest:category:#{category_id}:limit:35"

    ConCache.get_or_store :entries, key, fn ->
      qs =
        from(q in Entry, order_by: [desc: q.published_at], limit: 35)
        |> Entry.query(:index)
        |> Entry.published
        |> Entry.with_relation(Category)

      from([q, j] in qs, where: q.category_id == ^category_id)
      |> Repo.all
    end
  end

  defp ranked_entries(category_id), do: hottest_entries category_id
  defp hottest_entries(category_id) do
    key = "entries:hottest:category:#{category_id}:limit:35"

    ConCache.get_or_store :entries, key, fn ->
      qs =
        from(q in Entry, order_by: [asc: q.sort], limit: 35)
        |> Entry.query(:index)
        |> Entry.published
        |> Entry.with_relation(Category)

      from([q, j] in qs, where: q.category_id == ^category_id)
      |> Repo.all
    end
  end

  defp release_entries(category_id) do
    key = "entries:release:category:#{category_id}:limit:35"

    ConCache.get_or_store :entries, key, fn ->
      qs =
        from(q in Entry, order_by: [desc: q.release_date], limit: 35)
        |> Entry.query(:index)
        |> Entry.published
        |> Entry.with_relation(Category)

      from([q, j] in qs, where: q.category_id == ^category_id)
      |> Repo.all
    end
  end

  defp prerelease_entries(category_id) do
    key = "entries:prerelease:category:#{category_id}:limit:35"

    ConCache.get_or_store :entries, key, fn ->
      qs =
        from(q in Entry, order_by: [desc: q.release_date], limit: 35)
        |> Entry.query(:index)
        |> Entry.prereleased
        |> Entry.with_relation(Category)

      from([q, j] in qs, where: q.category_id == ^category_id)
      |> Repo.all
    end
  end


end
