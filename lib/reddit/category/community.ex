defmodule Reddit.Category.Community do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reddit.Users.User
  alias Reddit.Community.Subscription
  alias Reddit.Community.Post

  schema "communities" do
    field :name, :string
    field :rules, :string
    field :summary, :string
    field :members, :integer, default: 0
    belongs_to :user, User
    has_many :subscriptions, Subscription
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(community, attrs) do
    community
    |> cast(attrs, [:name, :summary, :rules, :members])
    |> validate_required([:name, :summary, :rules])
    |> trim_name()
    |> unique_constraint(:name)
  end

  defp trim_name(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        put_change(changeset, :name, clean_name(name))
      _ ->
        changeset
    end
  end

  defp clean_name(name) do
    name |> String.split |> Enum.join
  end

end
