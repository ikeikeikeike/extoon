defmodule Extoon.Entry do
  use Extoon.Web, :model

  schema "entries" do
    belongs_to :maker, Extoon.Maker
    has_many :thumbs, {"entries_thumbs", Extoon.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all

    field :url, :string
    field :title, :string
    field :content, :string
    field :seo_title, :string
    field :seo_content, :string
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

end
