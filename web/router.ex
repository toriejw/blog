defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Blog do
    pipe_through :browser

    get "/", PageController, :home
    get "/blog", PostController, :blog
    
    get "/admin", SessionsController, :new
    post "/admin", SessionsController, :create
    resources "/posts", PostController
    get "/dashboard", PostController, :index
  end
end
