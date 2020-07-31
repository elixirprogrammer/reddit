defmodule RedditWeb.CommunityView do
  use RedditWeb, :view

  import Inflex

  alias Inflex

  def pluralize(word, count) do
    Integer.to_string(count) <> " " <> inflect(word, (count))
  end
end
