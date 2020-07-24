defmodule Reddit.CategoryTest do
  use Reddit.DataCase

  alias Reddit.Category

  describe "communities" do
    alias Reddit.Category.Community

    @valid_attrs %{name: "some name", rules: "some rules", summary: "some summary"}
    @update_attrs %{name: "some updated name", rules: "some updated rules", summary: "some updated summary"}
    @invalid_attrs %{name: nil, rules: nil, summary: nil}

    def community_fixture(attrs \\ %{}) do
      {:ok, community} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Category.create_community()

      community
    end

    test "list_communities/0 returns all communities" do
      community = community_fixture()
      assert Category.list_communities() == [community]
    end

    test "get_community!/1 returns the community with given id" do
      community = community_fixture()
      assert Category.get_community!(community.id) == community
    end

    test "create_community/1 with valid data creates a community" do
      assert {:ok, %Community{} = community} = Category.create_community(@valid_attrs)
      assert community.name == "some name"
      assert community.rules == "some rules"
      assert community.summary == "some summary"
    end

    test "create_community/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Category.create_community(@invalid_attrs)
    end

    test "update_community/2 with valid data updates the community" do
      community = community_fixture()
      assert {:ok, %Community{} = community} = Category.update_community(community, @update_attrs)
      assert community.name == "some updated name"
      assert community.rules == "some updated rules"
      assert community.summary == "some updated summary"
    end

    test "update_community/2 with invalid data returns error changeset" do
      community = community_fixture()
      assert {:error, %Ecto.Changeset{}} = Category.update_community(community, @invalid_attrs)
      assert community == Category.get_community!(community.id)
    end

    test "delete_community/1 deletes the community" do
      community = community_fixture()
      assert {:ok, %Community{}} = Category.delete_community(community)
      assert_raise Ecto.NoResultsError, fn -> Category.get_community!(community.id) end
    end

    test "change_community/1 returns a community changeset" do
      community = community_fixture()
      assert %Ecto.Changeset{} = Category.change_community(community)
    end
  end
end
