defmodule Reddit.Community.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [where: 2]

  alias Reddit.Users.User
  alias Reddit.Category.Community
  alias Reddit.Community.Subscription
  alias Reddit.Repo

  @primary_key false
  schema "subscriptions" do
    belongs_to :user, User
    belongs_to :community, Community

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :community_id])
    |> validate_required([:user_id, :community_id])
  end

  def build_relationship(user, community) do
    Subscription.changeset(%Subscription{}, %{user_id: user, community_id: community})
    |> Repo.insert()
  end

  def delete_old_relationship(user, community) do
    Subscription
    |> where(user_id: ^user)
    |> where(community_id: ^community)
    |> Repo.delete_all()
  end
end
