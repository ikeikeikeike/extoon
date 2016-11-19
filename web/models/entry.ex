defmodule Extoon.Entry do
  use Extoon.Web, :model
  use ESx.Schema

  schema "entries" do
    belongs_to :maker, Extoon.Maker
    belongs_to :label, Extoon.Label
    belongs_to :series, Extoon.Series
    belongs_to :category, Extoon.Category

    has_one :info, {"entries_infos", Extoon.Info}, foreign_key: :assoc_id, on_delete: :delete_all, on_replace: :delete

    has_many :urls, Extoon.EntryUrl, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :embeds, Extoon.EntryEmbed, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :thumbs, {"entries_thumbs", Extoon.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all, on_replace: :delete

    many_to_many :tags, Extoon.Tag, join_through: "entries_tags", on_delete: :delete_all, on_replace: :delete

    field :title, :string
    field :content, :string
    field :duration, :integer
    field :release_date, Ecto.Date

    # field :review, :boolean, default: false
    # field :removal, :boolean, default: false
    field :publish, :boolean, default: false
    field :published_at, Ecto.DateTime

    timestamps()
  end

  mapping do
    indexes :title, type: "string", analyzer: "ja_analyzer"
    indexes :content, type: "string", analyzer: "ja_analyzer"
    indexes :publish, type: "boolean"
  end

  analysis do
    filter :ja_posfilter,
      type: "kuromoji_neologd_part_of_speech",
      stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

    tokenizer :ja_tokenizer,
      type: "kuromoji_neologd_tokenizer"

    analyzer :ja_analyzer,
      type: "custom", tokenizer: "ja_tokenizer",
      filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
  end

  @requires ~w(title)a
  @options ~w(
    maker_id category_id series_id label_id
    content duration release_date
    publish published_at updated_at
  )a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, @requires, @options)
    |> validate_required(@requires)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def info_changeset(st, params \\ %{}) do
    st
    |> changeset(params)
    |> put_assoc(:tags, params[:tags])
    |> cast_assoc(:thumbs, required: true)
    |> cast_assoc(:info, required: true)
  end

  def released(query),             do: from p in query, where: p.publish == true
  def unreleased(query),           do: from p in query, where: p.publish == false
  # def reviewed(query),             do: from p in query, where: p.review  == true
  # def unreviewed(query),           do: from p in query, where: p.review  == false
  # def removed(query),              do: from p in query, where: p.removal == true
  # def unremoved(query),            do: from p in query, where: p.removal == false
  # def more_than_10_minutes(query), do: from p in query, where: p.time    >= 600

  # return on publish record.
  #
  def published(query) do
    query
    |> released
    # |> reviewed
    # |> unremoved
  end

  # before release contents.
  #
  def reserved(query) do
    query
    |> unreleased
    # |> reviewed
    # |> unremoved
  end

  # default contents.
  #
  def initialized(query) do
    query
    |> unreleased
    # |> unreviewed
    # |> unremoved
  end

end
