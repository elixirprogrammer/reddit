defmodule RedditWeb.SubscriptionsLive do
  use RedditWeb, :live_view

  alias Reddit.Community.Subscription
  alias Reddit.Repo

  import Ecto.Query, only: [where: 2]

  def mount(_params, %{"current_user" => u_id, "community" => c_id}, socket) do
    if Subscription |> where(user_id: ^u_id) |> where(community_id: ^c_id) |> Repo.all() !== [] do
      socket =
      assign(socket,
      user: u_id,
      community: c_id,
      status: "Leave Community",
      btn_status: "secondary",
      disable_with: "Leaving...")

      {:ok , socket}
    else
      socket =
      assign(socket,
      user: u_id,
      community: c_id,
      status: "Join Community",
      btn_status: "success",
      disable_with: "Joining...")

      {:ok , socket}
    end
  end

  def render(assigns) do
    ~L"""
      <button class="btn btn-<%= @btn_status %> text-uppercase float-right"
              phx-value-user="<%= @user %>"
              phx-value-community="<%= @community %>"
              phx-click="toggle-status"
              phx-disable-with=<%= @disable_with %>>
            <%= @status %>
     </button>
    """
  end

  def handle_event("toggle-status", %{"user" => u_id, "community" => c_id}, socket) do
    if Subscription |> where(user_id: ^u_id) |> where(community_id: ^c_id) |> Repo.all() !== [] do
      Subscription.delete_old_relationship(u_id, c_id)

      socket =
      assign(socket,
      user: u_id,
      community: c_id,
      status: "Join Community",
      btn_status: "success",
      disable_with: "Joining...")

      :timer.sleep(500)

      {:noreply , socket}
    else
      Subscription.build_relationship(u_id, c_id)

      socket =
      assign(socket,
      user: u_id,
      community: c_id,
      status: "Leave Community",
      btn_status: "secondary",
      disable_with: "Leaving...")

      :timer.sleep(500)

      {:noreply , socket}
    end
  end
end
