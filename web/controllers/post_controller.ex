defmodule Blog.PostController do
  use Blog.Web, :controller
  # use Calecto.Model, usec: true

  alias Blog.Post
  # import Ecto.Changeset, only: [put_change: 3]

  plug :scrub_params, "post" when action in [:create, :update]

  def blog(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "blog.html", posts: posts)
  end

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)
    # |> put_change(:updated_at, )

    case Repo.insert(changeset) do
      {:ok, _post} ->
        # change_date_to_calendar(changeset)

        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  # defp change_date_to_calendar(changeset) do
  #   post = Repo.get_by!(Post, title: changeset.params["title"])
  #
  #   inserted_at = Calecto.Date(Ecto.DateTime.to_erl(post.inserted_at))
  #   # |> Calendar.Date
  #
  #   Post.changeset(post)
  #   |> put_change(:inserted_at, inserted_at)
  # end
end
