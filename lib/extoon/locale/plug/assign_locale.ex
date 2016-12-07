defmodule Extoon.Locale.Plug.AssignLocale do
  alias Extoon.Gettext, as: I18n
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    # {conn, lang_tag} = choose_locale_then_proxycache(conn)
    lang_tag = List.first(extract_accept_language(conn))

    locale = I18n.find_locale(lang_tag || I18n.default_locale)
    Plug.Conn.assign(conn, :locale, locale)
  end

  defp choose_locale_then_proxycache(conn) do
    if locale = conn.params["locale"] do
      conn = Plug.Conn.put_session(conn, :locale, locale)
    end

    ses = Plug.Conn.get_session(conn, :locale)
    ecc = List.first(extract_accept_language(conn))

    cond do
      ses ->
        # Plug.Conn.put_resp_header(conn, "X-Accel-Expires", "0")
        {conn, ses}
      ecc  ->
        {conn, ecc}
    end
  end

  # Adapted from http://code.parent.co/practical-i18n-with-phoenix-and-elixir/
  defp extract_accept_language(conn) do
    case conn |> Plug.Conn.get_req_header("accept-language") do
      [value|_] ->
        value
        |> String.replace(" ", "")
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality >= &2.quality))
        |> Enum.map(&(&1.tag))
      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures = ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
    |> Regex.named_captures(string)

    quality = case Float.parse(captures["quality"] || "1.0") do
      {val, _} -> val
      _ -> 1.0
    end

    %{tag: captures["tag"], quality: quality}
  end
end
