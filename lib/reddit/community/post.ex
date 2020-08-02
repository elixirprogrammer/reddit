defmodule Reddit.Community.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reddit.Category.Community
  alias Reddit.Users.User

  schema "posts" do
    field :body, :string
    field :title, :string
    field :upvote, :integer, default: 0
    field :downvote, :integer, default: 0
    field :comments, :integer, default: 0
    belongs_to :community, Community
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :upvote, :downvote, :comments])
    |> validate_required([:title, :body])
  end
end
