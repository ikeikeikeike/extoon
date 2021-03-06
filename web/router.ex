defmodule Extoon.Router do
  use Extoon.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Extoon.Locale.Plug.AssignLocale
    plug Extoon.Locale.Plug.HandleLocalizedPath
    plug Extoon.Locale.Plug.ConfigureGettext
  end

  pipeline :api do
    plug :accepts, ["json", "txt", "text", "xml"]
  end

  scope "/", Extoon do
    pipe_through :api

    get "/rss", RssController, :index
    get "/robots.txt", RobotController, :index
  end

  scope "/", Extoon do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    scope "/e" do
      get "/", EntryController, :index
      get "/prerelease", EntryController, :prerelease
      get "/latest", EntryController, :latest
      get "/hottest", EntryController, :hottest
    end

    scope "/release" do
      get "/:alias", EntryController, :release
      get "/", EntryController, :release
    end

    scope "/s" do
      get "/:id", EntryController, :show
    end

    scope "/suggest" do
      get "/e/:q", EntryController, :suggest
    end

    scope "/ranking" do
      get "/", RankingController, :index
    end

    # TODO: should be search maker_id from database instead of es
    scope "/maker" do
      get "/:q", EntryController, :index, as: :maker
    end

    # TODO: should be search series_id from database instead of es
    scope "/series" do
      get "/:q", EntryController, :index, as: :series
    end

    # TODO: should be search label_id from database instead of es
    scope "/label" do
      get "/:q", EntryController, :index, as: :label
    end

    scope "/c" do
      get "/latest/:alias", CategoryController, :latest
      get "/latest", CategoryController, :latest

      get "/hottest/:alias", CategoryController, :hottest
      get "/hottest", CategoryController, :hottest

      get "/:alias", CategoryController, :index
      get "/", CategoryController, :index

      # get "/:name/ranking", CategoryController, :ranking
    end

    scope "/rp" do
      # get  "/contact", ReceptionController, :contact
      # post "/contact", ReceptionController, :contact
      get  "/removal", ReceptionController, :removal
      post "/removal", ReceptionController, :removal
    end

    get "/about", AboutController, :index
  end

  scope "/ja", Extoon do
    pipe_through :browser

    get "/", HomeController, :index

    scope "/e" do
      get "/", EntryController, :index
      get "/prerelease", EntryController, :prerelease
      get "/latest", EntryController, :latest
      get "/hottest", EntryController, :hottest
    end

    scope "/release" do
      get "/:alias", EntryController, :release
      get "/", EntryController, :release
    end

    scope "/s" do
      get "/:id", EntryController, :show
    end

    scope "/suggest" do
      get "/e/:q", EntryController, :suggest
    end

    scope "/ranking" do
      get "/", RankingController, :index
    end

    # TODO: should be search maker_id from database instead of es
    scope "/maker" do
      get "/:q", EntryController, :index, as: :maker
    end

    # TODO: should be search series_id from database instead of es
    scope "/series" do
      get "/:q", EntryController, :index, as: :series
    end

    # TODO: should be search label_id from database instead of es
    scope "/label" do
      get "/:q", EntryController, :index, as: :label
    end

    scope "/c" do
      get "/latest/:alias", CategoryController, :latest
      get "/latest", CategoryController, :latest

      get "/hottest/:alias", CategoryController, :hottest
      get "/hottest", CategoryController, :hottest

      get "/:alias", CategoryController, :index
      get "/", CategoryController, :index

      # get "/:name/ranking", CategoryController, :ranking
    end

    scope "/rp" do
      # get  "/contact", ReceptionController, :contact
      # post "/contact", ReceptionController, :contact
      get  "/removal", ReceptionController, :removal
      post "/removal", ReceptionController, :removal
    end

    get "/about", AboutController, :index

  end

  scope "/en", Extoon do
    pipe_through :browser

    get "/", HomeController, :index

    scope "/e" do
      get "/", EntryController, :index
      get "/prerelease", EntryController, :prerelease
      get "/latest", EntryController, :latest
      get "/hottest", EntryController, :hottest
    end

    scope "/release" do
      get "/:alias", EntryController, :release
      get "/", EntryController, :release
    end

    scope "/s" do
      get "/:id", EntryController, :show
    end

    scope "/suggest" do
      get "/e/:q", EntryController, :suggest
    end

    scope "/ranking" do
      get "/", RankingController, :index
    end

    # TODO: should be search maker_id from database instead of es
    scope "/maker" do
      get "/:q", EntryController, :index, as: :maker
    end

    # TODO: should be search series_id from database instead of es
    scope "/series" do
      get "/:q", EntryController, :index, as: :series
    end

    # TODO: should be search label_id from database instead of es
    scope "/label" do
      get "/:q", EntryController, :index, as: :label
    end

    scope "/c" do
      get "/latest/:alias", CategoryController, :latest
      get "/latest", CategoryController, :latest

      get "/hottest/:alias", CategoryController, :hottest
      get "/hottest", CategoryController, :hottest

      get "/:alias", CategoryController, :index
      get "/", CategoryController, :index

      # get "/:name/ranking", CategoryController, :ranking
    end

    scope "/rp" do
      # get  "/contact", ReceptionController, :contact
      # post "/contact", ReceptionController, :contact
      get  "/removal", ReceptionController, :removal
      post "/removal", ReceptionController, :removal
    end

    get "/about", AboutController, :index

  end

  scope "/es", Extoon do
    pipe_through :browser

    get "/", HomeController, :index

    scope "/e" do
      get "/", EntryController, :index
      get "/prerelease", EntryController, :prerelease
      get "/latest", EntryController, :latest
      get "/hottest", EntryController, :hottest
    end

    scope "/release" do
      get "/:alias", EntryController, :release
      get "/", EntryController, :release
    end

    scope "/s" do
      get "/:id", EntryController, :show
    end

    scope "/suggest" do
      get "/e/:q", EntryController, :suggest
    end

    scope "/ranking" do
      get "/", RankingController, :index
    end

    # TODO: should be search maker_id from database instead of es
    scope "/maker" do
      get "/:q", EntryController, :index, as: :maker
    end

    # TODO: should be search series_id from database instead of es
    scope "/series" do
      get "/:q", EntryController, :index, as: :series
    end

    # TODO: should be search label_id from database instead of es
    scope "/label" do
      get "/:q", EntryController, :index, as: :label
    end

    scope "/c" do
      get "/latest/:alias", CategoryController, :latest
      get "/latest", CategoryController, :latest

      get "/hottest/:alias", CategoryController, :hottest
      get "/hottest", CategoryController, :hottest

      get "/:alias", CategoryController, :index
      get "/", CategoryController, :index

      # get "/:name/ranking", CategoryController, :ranking
    end

    scope "/rp" do
      # get  "/contact", ReceptionController, :contact
      # post "/contact", ReceptionController, :contact
      get  "/removal", ReceptionController, :removal
      post "/removal", ReceptionController, :removal
    end

    get "/about", AboutController, :index

  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", Extoon do
  #   pipe_through :api
  # end
end
