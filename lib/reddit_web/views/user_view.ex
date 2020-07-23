defmodule RedditWeb.UserView do
  use RedditWeb, :view

  def inserted_at(inserted_at) do
    Timex.format!(inserted_at, "%m/%d/%Y", :strftime)
  end
end
