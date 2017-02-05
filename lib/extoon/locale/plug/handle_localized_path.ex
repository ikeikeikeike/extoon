defmodule Extoon.Locale.Plug.HandleLocalizedPath do
  import Plug.Conn, only: [assign: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    supported_locales = Gettext.known_locales(Extoon.Gettext)
    case conn.path_info do
      [locale | rest] ->
        if locale in supported_locales do
          params = Map.merge conn.params, %{"hl" => locale}

          %{conn | path_info: rest}
          |> assign(:locale, locale)
          |> assign(:path_locale, locale)
          |> struct([params: params])
        else
          conn
        end
      _ ->
        conn
    end
  end
end
