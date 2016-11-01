defmodule Extoon.Router do
  use Extoon.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "txt", "text", "xml"]
  end

  scope "/", Extoon do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Extoon do
  #   pipe_through :api
  # end
end
