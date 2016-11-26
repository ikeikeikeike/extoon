defmodule Extoon.Entry do
  use Extoon.Web, :model
  use ESx.Schema

  alias Extoon.{Maker,Label,Series,Category,Info,Thumb,EntryUrl,EntryEmbed,Tag}

  schema "entries" do
    belongs_to :maker, Maker
    belongs_to :label, Label
    belongs_to :series, Series
    belongs_to :category, Category

    has_one :info, {"entries_infos", Info}, foreign_key: :assoc_id, on_delete: :delete_all, on_replace: :delete

    has_many :urls, EntryUrl, on_delete: :delete_all
    has_many :embeds, EntryEmbed, on_delete: :delete_all
    has_many :thumbs, {"entries_thumbs", Thumb}, foreign_key: :assoc_id, on_delete: :delete_all, on_replace: :delete

    many_to_many :tags, Tag, join_through: "entries_tags", on_delete: :delete_all, on_replace: :delete

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

  mapping _all: [enabled: false] do
    indexes :title, type: "string", analyzer: "ja_analyzer"
    indexes :content, type: "string", analyzer: "ja_analyzer"
    indexes :publish, type: "boolean"
  end

  settings do
    analysis do
      filter :ja_posfilter,
        type: "kuromoji_neologd_part_of_speech",
        stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

      tokenizer :ja_tokenizer,
        type: "kuromoji_neologd_tokenizer",
        mode: "search"

      analyzer :ja_analyzer,
        type: "custom", tokenizer: "ja_tokenizer",
        char_filter: ["html_strip", "kuromoji_neologd_iteration_mark"],
        filter: ["kuromoji_neologd_baseform", "kuromoji_neologd_stemmer", "ja_posfilter", "cjk_width"]
    end
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

  @query_index [:thumbs, :category, :maker]
  def query(query, :index) do
    from q in query,
    preload: ^@query_index
  end

  def query(query, :show) do
    from q in query,
    preload: [
      :embeds, :urls, :thumbs, :tags, :category,
      maker: [entries: [:thumbs]],
      label: [entries: [:thumbs]],
      series: [entries: [:thumbs]],
      # category: [entries: ^(from __MODULE__, limit: 5)],
      # ^(from __MODULE__, order_by: [desc: :id]
    ]
  end

  def categories(id) do
    from f in query(__MODULE__, :index),
      join: j in assoc(f, :category),
      where: j.id == f.category_id
        and f.category_id == ^id,
      order_by: [desc: f.id],
      limit: 5
  end

  def with_relation(query, Category = mod), do: from q in query, join: j in assoc(q, :category), where: j.id == q.category_id
  def with_relation(query, Series = mod), do: from q in query, join: j in assoc(q, :series), where: j.id == q.series_id
  def with_relation(query, Maker = mod), do: from q in query, join: j in assoc(q, :maker), where: j.id == q.maker_id
  def with_relation(query, LAbel = mod), do: from q in query, join: j in assoc(q, :label), where: j.id == q.label_id

  def released(query),      do: from q in query, where: q.publish == true
  def unreleased(query),    do: from q in query, where: q.publish == false
  # def reviewed(query),      do: from p in query, where: p.review  == true
  # def unreviewed(query),    do: from p in query, where: p.review  == false
  # def removed(query),       do: from p in query, where: p.removal == true
  # def unremoved(query),     do: from p in query, where: p.removal == false

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
