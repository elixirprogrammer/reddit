defmodule RedditWeb.PostLive.FormComponent do
  use RedditWeb, :live_component

  alias Reddit.Community

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Community.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Community.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params, "user" => user, "community" => community}, socket) do
    save_post(socket, socket.assigns.action, post_params, user, community)
  end

  defp save_post(socket, :edit, post_params) do
    case Community.update_post(socket.assigns.post, post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params, user, community) do
    post = post_params |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    case Community.create_post(user, community, post) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
