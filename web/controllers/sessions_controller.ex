defmodule Blog.SessionsController do
  use Blog.Web, :controller

  alias Blog.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case Blog.Session.login(session_params, Blog.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/dashboard")
      :error ->
        conn
        |> put_flash(:info, "It doesn't look like you're authorized for this.")
        |> render("new.html")
    end
  end
end
