defmodule Blog.Session do
  alias Blog.User

  def current_admin(conn) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id, do: Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_admin(conn)

  def login(params, repo) do
    user = repo.get_by(User, username: params["username"])
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> (password == user.crypted_password)
    end
  end
end
