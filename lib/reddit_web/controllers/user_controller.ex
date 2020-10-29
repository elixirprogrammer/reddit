defmodule RedditWeb.UserController do
  use RedditWeb, :controller

  alias Reddit.Users.User
  alias Reddit.Repo
  alias Reddit.Community, as: Post

  def profile(conn, %{"username" => username}) do
    logged_in_user_id = logged_in(conn.assigns.current_user)

    case User.profile(username) do
      nil ->
        redirect(conn, to: "/")
      user ->
        user_posts = Post.list_posts_by_users(user.id)
        render(conn, :profile, user: user, logged_in_user_id: logged_in_user_id, user_posts: user_posts)
    end
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
