defmodule Reddit.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities) do
      add :name, :text
      add :summary, :text
      add :rules, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:communities, [:user_id])

  end
end
