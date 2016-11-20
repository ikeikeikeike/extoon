# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Extoon.Repo.insert!(%Extoon.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query

alias Extoon.{Repo,Category}
alias Extoon.Ecto.Q

createable = fn queryable ->
  case Q.get_or_changeset(Category, queryable) do
    %Category{} = model ->
      nil
    changeset ->
      Repo.insert changeset
  end
end

[third: third, anime: anime, doujin: doujin, extra: extra] = Application.get_env :extoon, :categories

[alias: alias, kana: kana, romaji: romaji, gyou: gyou] = extra[:anime]
createable.(%{name: anime, alias: alias, kana: kana, romaji: romaji, gyou: gyou})

[alias: alias, kana: kana, romaji: romaji, gyou: gyou] = extra[:third]
createable.(%{name: third, alias: alias, kana: kana, romaji: romaji, gyou: gyou})

[alias: alias, kana: kana, romaji: romaji, gyou: gyou] = extra[:doujin]
createable.(%{name: doujin, alias: alias, kana: kana, romaji: romaji, gyou: gyou})
