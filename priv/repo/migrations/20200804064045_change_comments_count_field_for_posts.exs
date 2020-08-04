defmodule Reddit.Repo.Migrations.ChangeCommentsCountFieldForPosts do
  use Ecto.Migration

  def change do
    rename table("posts"), :comments, to: :comments_count
  end
end
