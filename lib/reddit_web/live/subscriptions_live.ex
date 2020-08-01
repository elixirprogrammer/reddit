defmodule RedditWeb.SubscriptionsLive do
  use RedditWeb, :live_view

  alias Reddit.Community.Subscription
  alias Reddit.Repo

  import Ecto.Query, only: [where: 2]

  def mount(_params, %{"current_user" => u_id, "community" => c_id}, socket) do
    subscribed? = subscribed?(u_id, c_id)

    socket =
      assign(socket,
      user: u_id,
      community: c_id,
      status: get_status(subscribed?),
      btn_status: get_btn_status(subscribed?),
      disable_with: get_disable_with(subscribed?))

    {:ok , socket}
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
    subscribed? = build_subscription(subscribed?(u_id, c_id), u_id, c_id)

    socket =
      assign(socket,
      status: get_status(subscribed?),
      btn_status: get_btn_status(subscribed?),
      disable_with: get_disable_with(subscribed?))

    :timer.sleep(500)

    {:noreply , socket}
  end

  defp subscribed?(user, community) do
    Subscription
    |> where(user_id: ^user)
    |> where(community_id: ^community)
    |> Repo.all()
  end

  defp build_subscription(subscribed?, user, community) do
    case subscribed? do
      [] ->
        Subscription.build_relationship(user, community)

        subscribed?(user, community)
      _ ->
        Subscription.delete_old_relationship(user, community)

        subscribed?(user, community)
    end
  end

  defp get_status(subscribed?) when subscribed? == [], do: "Join Community"
  defp get_status(_subscribed?), do: "Leave Community"
  defp get_btn_status(subscribed?) when subscribed? == [], do: "success"
  defp get_btn_status(_subscribed?), do: "secondary"
  defp get_disable_with(subscribed?) when subscribed? == [], do: "Joining..."
  defp get_disable_with(_subscribed?), do: "Leaving..."
end
