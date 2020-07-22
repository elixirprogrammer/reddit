defmodule Reddit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :username, :string, null: false
      add :full_name, :string
      add :bio, :string
      add :karma, :integer, default: 0

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
