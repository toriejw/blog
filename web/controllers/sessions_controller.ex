defmodule Blog.SessionsController do
  use Blog.Web, :controller

  alias Blog.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, _params) do
    
  end
end
