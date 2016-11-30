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
    indexes :maker, type: "string", index: "not_analyzed"
    indexes :label, type: "string", index: "not_analyzed"
    indexes :series, type: "string", index: "not_analyzed"
    indexes :category, type: "string", index: "not_analyzed"
    indexes :tags, type: "string", index: "not_analyzed"

    indexes :title, type: "string", analyzer: "ja_analyzer"
    indexes :content, type: "string", analyzer: "ja_analyzer"

    indexes :duration, type: "long"
    indexes :release_date, type: "date", format: "dateOptionalTime"

    indexes :publish, type: "boolean"

    indexes :rubytext, type: "string", analyzer: "rubytext_analyzer", store: true
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

      tokenizer :kuromoji_pserson_dic,
        type: "kuromoji_neologd_tokenizer"
        # user_dictionary: "person.dic"
      filter :katakana_readingform,
        type: "kuromoji_neologd_readingform",
        use_romaji: false
      filter :split_delimiter,
          type: "word_delimiter",
          generate_word_parts: true,
          generate_number_parts: false,
          catenate_words: false,
          catenate_numbers: false,
          catenate_all: false,
          split_on_case_change: false,
          preserve_original: false,
          split_on_numerics: false,
          stem_english_possessive: false
      analyzer :rubytext_analyzer,
        type: "custom",
        tokenizer: "kuromoji_pserson_dic",
        filter: ["katakana_readingform", "split_delimiter"]
    end
  end

  def as_indexed_json(st, opts) do
    %{
      maker: st.maker.name,
      category: st.category.name,
      label: get_in(st, [Access.key(:label), Access.key(:name)]),
      series: get_in(st, [Access.key(:series), Access.key(:name)]),
      tags: Enum.map(st.tags, & &1.name),
      title: st.title,
      rubytext: st.title,
      content: st.content,
      duration: st.duration,
      release_date: st.release_date,
      publish: st.publish,
    }
  end

  def esquery(params \\ %{}) do
    query = %{
      fields: [],
      query: %{
        filtered: %{
          query: %{
            match_all: %{}
          },
          filter: %{
            bool: %{
              must: [
                %{term: %{publish: true}},
              ]
            }
          },
        }
      }
    }

    query =
      unless q = params["q"], do: query, else: (
        multi_match = %{
          multi_match: %{
            query: q,
            fields: ~w(title content maker category label series tags)
          }
        }
        put_in(query, [:query, :filtered, :query], multi_match)
      )

    query
  end

  def essuggest(word) do
    query = %{
      fields: ["rubytext"],
      query: %{
        filtered: %{
          query: %{
            match: %{rubytext: word}
          },
          filter: %{
            bool: %{
              must: [
                %{term: %{publish: true}},
              ]
            }
          },
        }
      }
    }
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
  def publish_changeset(st, params \\ nil) do
    params = params || %{publish: true, published_at: Ecto.DateTime.utc}

    st
    |> cast(params, ~w(publish published_at)a, [])
    |> validate_required(~w(publish published_at)a)
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

  @query_doc [:category, :maker, :label, :series, :tags]
  def query(query, :doc) do
    from q in query,
    preload: ^@query_doc
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

  def released(query),        do: from q in query, where: q.publish == true
  def unreleased(query),      do: from q in query, where: q.publish == false
  def infoabled(query),       do: from q in query, where: not is_nil(q.maker_id) and not is_nil(q.category_id)
  def uninfoabled(query),     do: from q in query, where: is_nil(q.maker_id) and is_nil(q.category_id)
  def contentabled(query),    do: from q in query, where: q.content != "" and not is_nil(q.content)
  def uncontentabled(query),  do: from q in query, where: q.content == "" or is_nil(q.content)
  # def removed(query),       do: from p in query, where: p.removal == true
  # def unremoved(query),     do: from p in query, where: p.removal == false

  # return on publish record.
  #
  def published(query) do
    query
    |> released
    |> infoabled
    |> contentabled
    # |> unremoved
  end

  # before release contents.
  #
  def reserved(query) do
    query
    |> unreleased
    |> infoabled
    |> contentabled
    # |> unremoved
  end

  # before reserve status
  #
  def pre_reserved(query) do
    query
    |> unreleased
    |> infoabled
    |> uncontentabled
    # |> unremoved
  end

  # default contents.
  #
  def initialized(query) do
    query
    |> unreleased
    |> uninfoabled
    |> uncontentabled
    # |> unremoved
  end

end
