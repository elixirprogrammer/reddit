defmodule RedditWeb.UserController do
  use RedditWeb, :controller

  alias Reddit.Users.User

  def profile(conn, %{"username" => username}) do
    user = User.profile(username)

    if user do
      render(conn, :profile, user: user)
    else
      redirect(conn, to: "/")
    end
  end
end
