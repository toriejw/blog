defmodule Blog.SessionsController do
  use Blog.Web, :controller

  alias Blog.Sessions

  def new(conn, _params) do
    # changeset = Sessions.changeset(%Sessions{})
    render(conn, "new.html")
  end
end
