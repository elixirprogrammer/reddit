defmodule Reddit.Community do
  @moduledoc """
  The Community context.
  """
  import Ecto
  import Ecto.Query, only: [from: 2]
  import Ecto.Query, warn: false
  alias Reddit.Repo

  alias Reddit.Community.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post) |> Repo.preload([:user, :community])
  end

  def list_posts_by_communties(c_id) do
    query = from p in Post, where: p.community_id == ^c_id
    Repo.all(query) |> Repo.preload([:user, :community])
  end

  def list_popular_posts do
    query = from p in Post, order_by: [desc: :votes_count], limit: 5
    Repo.all(query) |> Repo.preload([:user, :community])
  end

  def list_posts_by_users(u_id) do
    query = from p in Post, where: p.user_id == ^u_id
    Repo.all(query) |> Repo.preload([:user, :community])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, community, post) do
    p = Ecto.build_assoc(user, :posts, post)

    Ecto.build_assoc(community, :posts, p)
    |> Repo.insert()
 end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def votes_count(post) do
    post
    |> assoc(:votes)
    |> Repo.aggregate(:count, :user_id)
  end

  def votes_count_update(post_id, count) do
    from(p in Post, update: [inc: [votes_count: ^count]], where: p.id == ^post_id)
    |> Repo.update_all([])
  end

end
