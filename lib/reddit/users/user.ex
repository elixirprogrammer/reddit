defmodule Reddit.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword]

  import Ecto.Changeset

  alias Reddit.Users.User
  alias Reddit.Repo
  alias Reddit.Category.Community

  schema "users" do
    pow_user_fields()

    field :username, :string
    field :full_name, :string
    field :bio, :string
    field :karma, :integer, default: 0
    has_many :communities, Community

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:username, :full_name, :bio, :karma])
    |> validate_required([:username, :full_name])
    |> validate_length(:full_name, min: 4)
    |> validate_length(:username, min: 4)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def profile(param) do
    Repo.get_by(User, username: param)
  end
end
