defmodule Extoon.ThumbUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  require Logger

  @versions [:original, :suggest]
  @extension_whitelist ~w(.jpg .jpeg .gif .png .ico .bmp)

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:original, _) do
    conv = fn(input, output) ->
      File.copy input, output

      :os.cmd 'jpegoptim --strip-all --max=90 #{output}'

      ""
    end

    {:echo, conv, :jpg}
  end

  @s_wxh "96x54"
  def transform(:suggest, _) do
    conv = fn(input, output) ->
      :os.cmd 'convert -quality 100 -resize #{@s_wxh}^ -gravity center ' ++
              '-crop #{@s_wxh}+0+0 +repage #{input} #{output}'

      :os.cmd 'jpegoptim --strip-all --max=90 #{output}'

      ""
    end

    {:echo, conv, :jpg}
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: Plug.MIME.path(file.file_name)] # for "image.png", would produce: "image/png"
  end

  # def __storage, do: Arc.Storage.Local
  # def __storage, do: Arc.Storage.S3

  def filename(version, {file, model}) do
    fname = file.file_name
    fname = String.replace(fname, Path.extname(fname), "")

    "#{version}_#{fname}"
  end

  def storage_dir(_version, {_file, model}) do
    dirname =
      model.__struct__
      |> String.Chars.to_string
      |> String.downcase
      |> String.split(".")
      |> List.last

    "uploads/#{dirname}/#{model.assoc_id}"
  end

  def default_url(:original) do
    "https://placehold.it/300x200"
  end

  def default_url(:suggest) do
    "https://placehold.it/#{@s_wxh}"
  end

end
