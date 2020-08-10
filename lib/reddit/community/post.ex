defmodule Reddit.Community.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reddit.Category.Community
  alias Reddit.Users.User
  alias Reddit.Comments.Comment
  alias Reddit.Votes.Vote

  schema "posts" do
    field :body, :string
    field :title, :string
    field :votes_count, :integer, default: 0
    belongs_to :community, Community
    belongs_to :user, User
    has_many :comments, Comment
    has_many :votes, Vote

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :upvotes, :downvotes, :comments_count])
    |> validate_required([:title, :body])
  end
end
