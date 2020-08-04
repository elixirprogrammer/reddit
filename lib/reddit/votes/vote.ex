defmodule Reddit.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reddit.Users.User
  alias Reddit.Community.Post

  schema "votes" do
    field :downvote, :boolean, default: false
    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:downvote])
    |> validate_required([:downvote])
  end
end
