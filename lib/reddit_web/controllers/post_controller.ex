defmodule RedditWeb.PostController do
  use RedditWeb, :controller

  def show(conn, _params) do
    render conn, :show
  end
end
