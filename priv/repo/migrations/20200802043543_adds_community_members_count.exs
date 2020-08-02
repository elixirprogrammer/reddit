defmodule Reddit.Repo.Migrations.AddsCommunityMembersCount do
  use Ecto.Migration

  def change do
    alter table(:communities) do
      add :members, :integer, default: 0
    end
  end
end
