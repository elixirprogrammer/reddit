defmodule Reddit.Repo.Migrations.VotesUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:votes, [:user_id, :post_id])
  end
end
