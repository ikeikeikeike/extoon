defmodule Extoon.Repo do
  use Ecto.Repo, otp_app: :extoon
  use Scrivener, page_size: 33
end
