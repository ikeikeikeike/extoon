defmodule Extoon.Thumb do
  use Extoon.Web, :model
  use Extoon.Checks.Ecto
  use Arc.Ecto.Schema

  alias Extoon.ThumbUploader

  # @json_fields ~w(name src ext mime width height)
  # @derive {Poison.Encoder, only: Enum.map(@json_fields, & String.to_atom(&1))}
  schema "thumbs" do
    field :assoc_id, :integer

    field :src, ThumbUploader.Type
    field :name, :string
    field :ext, :string
    field :mime, :string
    field :width, :integer
    field :height, :integer

    timestamps()
  end

  @requires ~w()a
  @options ~w(assoc_id name ext mime width height)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [], @options)
    |> cast_attachments(params, [:src])
    |> validate_required([:src])
  end

  # fetch icon url
  def get_thumb(%__MODULE__{src: nil}), do: nil
  def get_thumb(st), do: ThumbUploader.url {st.src, st}
  def get_thumb(st, version), do: ThumbUploader.url {st.src, st}, version

end
