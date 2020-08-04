defmodule Reddit.CommunityTest do
  use Reddit.DataCase

  alias Reddit.Community

  describe "posts" do
    alias Reddit.Community.Post

    @valid_attrs %{body: "some body", title: "some title"}
    @update_attrs %{body: "some updated body", title: "some updated title"}
    @invalid_attrs %{body: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Community.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Community.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Community.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Community.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Community.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Community.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Community.update_post(post, @invalid_attrs)
      assert post == Community.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Community.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Community.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Community.change_post(post)
    end
  end

  describe "comments" do
    alias Reddit.Community.Comment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Community.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Community.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Community.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Community.create_comment(@valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Community.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Community.update_comment(comment, @update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Community.update_comment(comment, @invalid_attrs)
      assert comment == Community.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Community.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Community.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Community.change_comment(comment)
    end
  end
end
