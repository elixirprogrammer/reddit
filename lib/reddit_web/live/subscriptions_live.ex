defmodule RedditWeb.SubscriptionsLive do
  use RedditWeb, :live_view

  def mount(_params, %{"current_user" => user_id}, socket) do
    socket =
      assign(socket,
      user: user_id,
      status: "Join Community",
      btn_status: "success",
      disable_with: "Joining...")

    {:ok , socket}
  end

  def render(assigns) do
    ~L"""
      <button class="btn btn-<%= @btn_status %> text-uppercase float-right" phx-click="toggle-status"
    phx-disable-with=<%= @disable_with %>>
            <%= @status %>
     </button>
    """
  end

  def handle_event("toggle-status", _, socket) do
    socket =
      assign(socket,
      status: "Leave Community",
      btn_status: "secondary",
      disable_with: "Leaving...")

    :timer.sleep(500)

    {:noreply, socket}
  end
end
