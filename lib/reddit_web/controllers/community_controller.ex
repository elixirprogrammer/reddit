defmodule RedditWeb.CommunityController do
  use RedditWeb, :controller

  alias Reddit.Category
  alias Reddit.Category.Community
  alias Reddit.Users.User
  alias Reddit.Repo
  alias Reddit.Community, as: Post

  def index(conn, _params) do
    communities = Category.list_communities()
    render(conn, "index.html", communities: communities)
  end

  def new(conn, _params) do
    changeset = Category.change_community(%Community{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"community" => community_params}) do
    #community = Map.put(community_params, "user_id", Integer.to_string(conn.assigns.current_user.id))
    community = community_params |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    case Category.create_community(conn.assigns.current_user, community) do
      {:ok, community} ->
        User.karma_update(conn.assigns.current_user.id, 1)

        conn
        |> put_flash(:info, "Community created successfully.")
        |> redirect(to: Routes.community_path(conn, :show, community.name))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"name" => name}) do
    logged_in_user_id = logged_in(conn.assigns.current_user)

    case Repo.get_by(Community, name: name) do
      nil ->
        redirect(conn, to: "/")
      community ->
        posts = Post.list_posts_by_communties(community.id)
        render(conn, "show.html", community: community, posts: posts, logged_in_user_id: logged_in_user_id)
    end
  end

  def edit(conn, %{"id" => id}) do
    community = Category.get_community!(id)
    changeset = Category.change_community(community)
    render(conn, "edit.html", community: community, changeset: changeset)
  end

  def update(conn, %{"id" => id, "community" => community_params}) do
    community = Category.get_community!(id)

    case Category.update_community(community, community_params) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community updated successfully.")
        |> redirect(to: Routes.community_path(conn, :show, community))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", community: community, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    community = Category.get_community!(id)
    {:ok, _community} = Category.delete_community(community)

    conn
    |> put_flash(:info, "Community deleted successfully.")
    |> redirect(to: Routes.community_path(conn, :index))
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
