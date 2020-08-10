defmodule RedditWeb.VotesLive do
  use RedditWeb, :live_view

  alias Reddit.Repo
  alias Reddit.Users.User
  alias Reddit.Community
  alias Reddit.Votes.Vote
  alias Reddit.Votes

  def mount(_params, %{"post_id" => p_id, "user_id" => u_id}, socket) do
    post = Community.get_post!(p_id)

    socket =
      assign(socket,
      p_votes_count: post.votes_count,
      active_dislike?: current_user_downvoted?(u_id, p_id),
      active?: current_user_voted?(u_id, p_id),
      p_id: p_id,
      u_id: u_id)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div phx-value-u_id="<%= @u_id %>"
           phx-value-p_id="<%= @p_id %>"
           class="fa fa-arrow-up upvote <%= @active? %>"
           phx-click="upvote"></div>
      <span class="font-weight-bold score"><%= @p_votes_count %></span>
      <div class="fa fa-arrow-down downvote <%= @active_dislike? %>"
           phx-value-u_id="<%= @u_id %>"
           phx-value-p_id="<%= @p_id %>"
           phx-click="downvote"></div>
    """
  end

  def handle_event("upvote", %{"p_id" => post_id, "u_id" => user_id}, socket) do
    if user_id == "false" do
      {:noreply, redirect(socket, to: Routes.pow_session_path(socket, :new), replace: true)}
    else
      user = Repo.get!(User, user_id)
      post = Community.get_post!(post_id)
      vote = %Vote{}

      case current_user_voted?(user_id, post_id) do
        "" ->
          case Votes.create_vote(user, post, vote) do
            {:ok, _vote} ->
              User.karma_update(user_id, 1)
              post = Community.get_post!(post_id)
              if post.votes_count == -1 do
                Community.votes_count_update(post_id, 2)
              else
                Community.votes_count_update(post_id, 1)
              end
              post = Community.get_post!(post_id)
              socket =
                assign(socket,
                p_votes_count: post.votes_count,
                active?: "active",
                p_id: post_id,
                u_id: user_id)

              {:noreply, socket}
            {:error, %Ecto.Changeset{} = changeset} ->
              socket = assign(socket, changeset: changeset)
              {:noreply, socket}
          end
        "active" ->
            Votes.delete_vote(Votes.find_vote(user_id, post_id))
            User.karma_update(user_id, -1)
            Community.votes_count_update(post_id, -1)
            post = Community.get_post!(post_id)
            socket =
            assign(socket,
            p_votes_count: post.votes_count,
            active?: "",
            p_id: post_id,
            u_id: user_id)
          {:noreply, socket}
        nil ->
          vote = Votes.find_vote(user_id, post_id)
          case Votes.update_vote(vote, %{downvote: false}) do
            {:ok, _vote} ->
              User.karma_update(user_id, 1)
              post = Community.get_post!(post_id)
              if post.votes_count == -1 do
                Community.votes_count_update(post_id, 2)
              else
                Community.votes_count_update(post_id, 1)
              end
              post = Community.get_post!(post_id)
              socket =
              assign(socket,
              p_votes_count: post.votes_count,
              active?: "active",
              active_dislike?: "",
              p_id: post_id,
              u_id: user_id)

              {:noreply, socket}

            {:error, %Ecto.Changeset{} = changeset} ->
              socket = assign(socket, changeset: changeset)
              {:noreply, socket}
        end
      end
    end
  end

  def handle_event("downvote", %{"p_id" => post_id, "u_id" => user_id}, socket) do
    if user_id == "false" do
      {:noreply, redirect(socket, to: Routes.pow_session_path(socket, :new), replace: true)}
    else
      case current_user_downvoted?(user_id, post_id) do
        "active" ->
          Votes.delete_vote(Votes.find_vote(user_id, post_id))
          User.karma_update(user_id, 1)
          post = Community.get_post!(post_id)
          if  post.votes_count !== 0 do
            Community.votes_count_update(post_id, 1)
          end
          post = Community.get_post!(post_id)
          socket =
          assign(socket,
          p_votes_count: post.votes_count,
          active_dislike?: "",
          p_id: post_id,
          u_id: user_id)
          {:noreply, socket}
        "" ->
          user = Repo.get!(User, user_id)
          post = Community.get_post!(post_id)
          vote = %Vote{downvote: true}

          case Votes.create_vote(user, post, vote) do
            {:ok, _vote} ->
              User.karma_update(user_id, -1)
              Community.votes_count_update(post_id, -1)
              post = Community.get_post!(post_id)
              socket =
                assign(socket,
                p_votes_count: post.votes_count,
                active?: "",
                active_dislike?: "active",
                p_id: post_id,
                u_id: user_id)

              {:noreply, socket}
            {:error, %Ecto.Changeset{} = changeset} ->
              socket = assign(socket, changeset: changeset)
              {:noreply, socket}
          end
        nil ->
          vote = Votes.find_vote(user_id, post_id)

          case Votes.update_vote(vote, %{downvote: true}) do
            {:ok, _vote} ->
              User.karma_update(user_id, -1)
              Community.votes_count_update(post_id, -1)
              post = Community.get_post!(post_id)
              socket =
              assign(socket,
              p_votes_count: post.votes_count,
              active?: "",
              active_dislike?: "active",
              p_id: post_id,
              u_id: user_id)

              {:noreply, socket}

            {:error, %Ecto.Changeset{} = changeset} ->
              socket = assign(socket, changeset: changeset)
              {:noreply, socket}
          end
      end
    end
  end

  defp current_user_voted?(user_id, post_id) do
    if user_id == false or user_id == "false" do
      ""
    else
      voted? = Votes.find_vote(user_id, post_id)
      if voted? == nil do
        ""
      else
        if voted?.downvote == true do
          nil
        else
          "active"
        end
      end
    end
  end

  defp current_user_downvoted?(user_id, post_id) do
    if user_id == "false" or user_id == "false" do
      ""
    else
      downvoted? = Votes.find_vote(user_id, post_id)
      case downvoted? do
        nil ->
          ""
        downvoted? ->
          if downvoted?.downvote == true do
            "active"
          else
            nil
          end
      end
    end
  end

end
