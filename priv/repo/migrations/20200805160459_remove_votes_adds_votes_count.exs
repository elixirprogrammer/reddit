defmodule Reddit.Repo.Migrations.RemoveVotesAddsVotesCount do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :downvotes
      remove :upvotes
      add :votes_count, :integer, default: 0
    end
  end
end
