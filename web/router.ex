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

    scope "/s" do
      get "/:id", EntryController, :show
    end

    scope "/c" do
      get "/latest/:alias", CategoryController, :latest
      get "/latest", CategoryController, :latest

      get "/popular/:alias", CategoryController, :popular
      get "/popular", CategoryController, :popular

      get "/:alias", CategoryController, :index
      get "/", CategoryController, :index

      # get "/:name/ranking", CategoryController, :ranking
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Extoon do
  #   pipe_through :api
  # end
end
