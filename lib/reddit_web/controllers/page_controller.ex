defmodule RedditWeb.PageController do
  use RedditWeb, :controller

  alias Reddit.Category

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
    render conn, :index, communities: communities
  end
end
