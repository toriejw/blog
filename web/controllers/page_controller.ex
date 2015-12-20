defmodule Blog.PageController do
  use Blog.Web, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end
end
