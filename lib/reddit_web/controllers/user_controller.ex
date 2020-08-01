defmodule RedditWeb.UserController do
  use RedditWeb, :controller

  alias Reddit.Users.User

  def profile(conn, %{"username" => username}) do
    case User.profile(username) do
      nil ->
        redirect(conn, to: "/")
      user ->
        render(conn, :profile, user: user)
    end
  end

end
