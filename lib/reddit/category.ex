defmodule Reddit.Category do
  @moduledoc """
  The Category context.
  """

  import Ecto.Query, warn: false
  alias Reddit.Repo

  alias Reddit.Category.Community

  @doc """
  Returns the list of communities.

  ## Examples

      iex> list_communities()
      [%Community{}, ...]

  """
  def list_communities do
    Repo.all(Community)
  end

  @doc """
  Gets a single community.

  Raises `Ecto.NoResultsError` if the Community does not exist.

  ## Examples

      iex> get_community!(123)
      %Community{}

      iex> get_community!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community!(id), do: Repo.get!(Community, id)

  @doc """
  Creates a community.

  ## Examples

      iex> create_community(%{field: value})
      {:ok, %Community{}}

      iex> create_community(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community(attrs \\ %{}) do
    %Community{}
    |> Community.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community.

  ## Examples

      iex> update_community(community, %{field: new_value})
      {:ok, %Community{}}

      iex> update_community(community, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community(%Community{} = community, attrs) do
    community
    |> Community.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a community.

  ## Examples

      iex> delete_community(community)
      {:ok, %Community{}}

      iex> delete_community(community)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community(%Community{} = community) do
    Repo.delete(community)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community changes.

  ## Examples

      iex> change_community(community)
      %Ecto.Changeset{data: %Community{}}

  """
  def change_community(%Community{} = community, attrs \\ %{}) do
    Community.changeset(community, attrs)
  end
end
