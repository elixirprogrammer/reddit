defmodule RedditWeb.PageController do
  use RedditWeb, :controller

  alias Reddit.Category
  alias Reddit.Community, as: Post

### def index(conn, _params) do
###    if Pow.Plug.current_user(conn) do
###     conn
###      |> redirect(to: "/")
###   else
###      render conn, :index
###    end
###  end

  def index(conn, _params) do
    communities = Category.list_communities()
    posts = Post.list_posts()
    logged_in_user_id = logged_in(conn.assigns.current_user)
    render conn, :index, communities: communities, posts: posts, logged_in_user_id: logged_in_user_id
  end

  defp logged_in(current_user) do
    case current_user do
      nil ->
        false
      current_user ->
        current_user.id
    end
  end
end
