defmodule Reddit.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reddit.Users.User
  alias Reddit.Community.Post

  schema "comments" do
    field :body, :string
    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
