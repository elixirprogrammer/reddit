defmodule RedditWeb.PostController do
  use RedditWeb, :controller

  alias Reddit.Community, as: CommunityPost
  alias Reddit.Community.Post
  alias Reddit.Category.Community
  alias Reddit.Category
  alias Reddit.Users.User
  alias Reddit.Repo

  def show(conn, %{"id" => id}) do
    logged_in_user_id = logged_in(conn.assigns.current_user)

    post = CommunityPost.get_post!(id) |> Repo.preload([:community, :comments])
    render(conn, :show, post: post, community: post.community, logged_in_user_id: logged_in_user_id)
  end

  def new(conn, %{"community_id" => community_id}) do
    community = Category.get_community!(community_id)
    changeset = CommunityPost.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, community: community)
  end

  def create(conn, %{"post" => post_params, "community_id" => community_id}) do
    community = Category.get_community!(community_id)
    post = post_params |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    case CommunityPost.create_post(conn.assigns.current_user, community, post) do
      {:ok, post} ->
        User.karma_update(conn.assigns.current_user.id, 1)

        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, community.name, post.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, community_id: community_id)
    end
  end

  defp logged_in(current_user) do
    case current_user do
      nil ->
        false
      current_user ->
        current_user.id
    end
  end
end
