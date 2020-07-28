defmodule Reddit.Community.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reddit.Users.User
  alias Reddit.Category.Community

  schema "subscriptions" do
    belongs_to :user, User
    belongs_to :community, Community

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [])
    |> validate_required([])
  end
end
