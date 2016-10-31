defmodule Extoon.Thumb do
  use Extoon.Web, :model
  use Arc.Ecto.Schema

  @json_fields ~w(name src ext mime width height)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, & String.to_atom(&1))}
  schema "thumbs" do
    field :assoc_id, :integer

    field :name, :string
    field :src, Extoon.ThumbUploader.Type
    field :ext, :string
    field :mime, :string
    field :width, :integer
    field :height, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(st, params \\ %{}) do
    st
    |> cast(params, [], [:assoc_id, :name, :ext, :mime, :width, :height])
    |> cast_attachments(params, [:src])
    |> validate_required([:src])
  end

  # fetch icon url
  def get_thumb(st), do: ThumbUploader.url {st.image, st}
  def get_thumb(st, version), do: ThumbUploader.url {st.image, st}, version

  # def create_by_scrapy(entry, scrapy) do
    # image =
      # "#{Application.get_env(:exblur, :scrapy)[:endpoint]}#{scrapy["path"]}"
      # |> Plug.Exblur.Upload.make_plug!

    # params = %{"entry_id" => entry.id, "image" => image}
    # case Repo.insert(changeset(%Model{}, params)) do
      # {:error, reason} ->
        # Logger.error("#{inspect reason}")
        # {:error, reason}

      # {_, model} ->
        # {:ok, model}
    # end
  # end


end
