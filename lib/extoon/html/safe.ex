defmodule Extoon.HTML.Safe do

  def safe_router(path) do
    Regex.replace(~r/\\|\/|\:|\(|\)\|\'|\?|&/, path, "-")
  end

  defdelegate urlable(path), to: __MODULE__, as: :safe_router

end
