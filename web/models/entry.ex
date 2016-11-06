defmodule Extoon.Entry do
  use Extoon.Web, :model

  schema "entries" do
    belongs_to :maker, Extoon.Maker
    belongs_to :label, Extoon.Label
    belongs_to :series, Extoon.Series
    belongs_to :category, Extoon.Category

    has_many :urls, Extoon.EntryUrl, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :embeds, Extoon.EntryEmbed, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :thumbs, {"entries_thumbs", Extoon.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all

    field :title, :string
    field :content, :string
    field :seo_title, :string
    field :seo_content, :string

    field :duration, :integer

    # field :review, :boolean, default: false
    # field :removal, :boolean, default: false
    field :publish, :boolean, default: false
    field :published_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(st, params \\ %{}) do
    chset =
      st
      |> cast(params, [:url, :title], [:content, :seo_title, :seo_content, :published_at, :maker_id])
      |> validate_required([:url, :title])
      |> validate_format(:url, ~r/^https?:\/\//)

  end

  def thumbs_changeset(st, params \\ %{}) do
    # Extoon.Image.Plug.Upload.make_plug!

    st
    |> changeset(params)
    |> cast_assoc(:thumbs, required: true)
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
