defmodule Extoon.Image.Plug.Upload do
  require Logger
  alias Extoon.Http.Client.Plugupload

  def make_plug!(uri, opts \\ []) do
    r = recursive_request!(uri)

    basename = Path.basename URI.parse(uri).path
    filename =
      case opts[:orig] do
        true ->
          basename
        _ ->
          hashstring =
            :erlang.md5(r.body)
            |> Base.encode16(case: :lower)

          hashstring <> Path.extname(basename)
      end

    path = "/tmp/#{filename}"
    File.write!(path, r.body)

    %Plug.Upload{path: path, filename: filename}
  end

  defp recursive_request!(uri, retry \\ 10) do
    case Plugupload.get(uri) do
      {:error, reason} ->
        Logger.warn "#{inspect reason}"

        if retry < 1 do
          throw(reason)
        end

        uri
        |> recursive_request!(retry - 1)

      {_, r} -> r
    end
  end

end
