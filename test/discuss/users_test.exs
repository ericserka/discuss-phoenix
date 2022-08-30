defmodule Discuss.UsersTest do
  use Discuss.DataCase

  alias Discuss.Users

  describe "users" do
    alias Discuss.Users.User

    import Discuss.UsersFixtures

    @invalid_attrs %{avatar: nil, email: nil, name: nil, provider: nil, provider_id: nil, token: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{avatar: "some avatar", email: "some email", name: "some name", provider: "some provider", provider_id: 42, token: "some token"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.avatar == "some avatar"
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.provider == "some provider"
      assert user.provider_id == 42
      assert user.token == "some token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{avatar: "some updated avatar", email: "some updated email", name: "some updated name", provider: "some updated provider", provider_id: 43, token: "some updated token"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.avatar == "some updated avatar"
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.provider == "some updated provider"
      assert user.provider_id == 43
      assert user.token == "some updated token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
