defmodule RedditWeb.CommentsLive do
  use RedditWeb, :live_view

  alias Reddit.Comments
  alias Reddit.Comments.Comment
  alias Reddit.Repo
  alias Reddit.Users.User
  alias Reddit.Community

  def mount(_params, %{"post" => post, "user_id" => user_id}, socket) do
    changeset = Comments.change_comment(%Comment{})
    comments = post.comments |> Repo.preload(:user)

    socket =
      assign(socket,
        u_id: user_id,
        p_id: post.id,
        comments: comments,
        changeset: changeset
      )

    {:ok, socket, temporary_assigns: [comments: []]}
  end

  def handle_event("save", %{"comment" => params}, socket) do
    user = Repo.get!(User, params["u_id"])
    post = Community.get_post!(params["p_id"])
    comment = params |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    case Comments.create_comment(user, post, comment) do
      {:ok, comment} ->
        comment = comment |> Repo.preload(:user)
        socket =
          update(
            socket,
            :comments,
            fn comments -> [comment | comments] end
          )

        changeset = Comments.change_comment(%Comment{})

        socket = assign(socket, changeset: changeset)

        :timer.sleep(500)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end
end
