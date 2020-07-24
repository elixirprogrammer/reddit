defmodule Reddit.Category.Community do
  use Ecto.Schema
  import Ecto.Changeset

  schema "communities" do
    field :name, :string
    field :rules, :string
    field :summary, :string

    timestamps()
  end

  @doc false
  def changeset(community, attrs) do
    community
    |> cast(attrs, [:name, :summary, :rules])
    |> validate_required([:name, :summary, :rules])
  end
end
