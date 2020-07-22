defmodule RedditWeb.PageController do
  use RedditWeb, :controller

### def index(conn, _params) do
###    if Pow.Plug.current_user(conn) do
###     conn
###      |> redirect(to: "/")
###   else
###      render conn, :index
###    end
###  end

  def index(conn, _params) do
    render conn, :index
  end
end
