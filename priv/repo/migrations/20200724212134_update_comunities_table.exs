defmodule Reddit.Repo.Migrations.UpdateComunitiesTable do
  use Ecto.Migration

  def change do
    alter table(:communities) do
      modify :name, :text
    end

    create unique_index(:communities, [:name])

  end
end
