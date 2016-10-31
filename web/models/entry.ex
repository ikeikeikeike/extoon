defmodule Extoon.Entry do
  use Extoon.Web, :model

  schema "entries" do
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
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title], [:content, :seo_title, :seo_content, :published_at])
    |> validate_required([:url, :title])
  end
end
