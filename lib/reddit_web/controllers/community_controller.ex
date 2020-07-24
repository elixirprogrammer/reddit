defmodule RedditWeb.CommunityController do
  use RedditWeb, :controller

  alias Reddit.Category
  alias Reddit.Category.Community

  def index(conn, _params) do
    communities = Category.list_communities()
    render(conn, "index.html", communities: communities)
  end

  def new(conn, _params) do
    changeset = Category.change_community(%Community{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"community" => community_params}) do
    case Category.create_community(community_params) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community created successfully.")
        |> redirect(to: Routes.community_path(conn, :show, community))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    community = Category.get_community!(id)
    render(conn, "show.html", community: community)
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
end
