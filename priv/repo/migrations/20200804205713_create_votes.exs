defmodule Reddit.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :downvote, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

    create index(:votes, [:user_id])
    create index(:votes, [:post_id])
  end
end
