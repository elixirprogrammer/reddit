defmodule Reddit.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :community_id, references(:communities, on_delete: :nothing)

      timestamps()
    end

    create index(:subscriptions, [:user_id])
    create index(:subscriptions, [:community_id])
  end
end
