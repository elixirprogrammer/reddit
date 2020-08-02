defmodule Reddit.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :upvotes, :integer, default: 0
      add :downvotes, :integer, default: 0
      add :comments, :integer, default: 0
      add :community_id, references(:communities, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:community_id])
    create index(:posts, [:user_id])
  end
end
