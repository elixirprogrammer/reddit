defmodule Reddit.Repo.Migrations.SubscribtionUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:subscriptions, [:user_id, :community_id])
  end

end
