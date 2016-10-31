defmodule Extoon.Image.Plug.Upload do
  require Logger

  @agents Application.get_env(:extoon, :user_agents)

  def make_plug!(filename) do
    basename = Path.basename URI.parse(filename).path

    resp = recursive_request!(filename)

    path = "/tmp/#{basename}"
    File.write!(path, resp.body)

    %Plug.Upload{path: path, filename: basename}
  end

  defp recursive_request!(filename, retry \\ 10) do
    opts = [{"User-agent", @agents[:image]}, {"connect_timeout", 30}]
    case HTTPoison.get(filename, opts) do
      {:error, reason} ->
        Logger.warn "#{inspect reason}"

        if retry < 1 do
          throw(reason)
        end

        filename
        |> recursive_request!(retry - 1)

      {_, resp} -> resp
    end
  end

end
