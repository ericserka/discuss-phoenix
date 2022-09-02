defmodule Discuss.UsersTest do
  use Discuss.DataCase

  alias Discuss.Users

  describe "users" do
    alias Discuss.Users.User

    import Discuss.UsersFixtures

    @invalid_attrs %{
      avatar: nil,
      email: nil,
      name: nil,
      provider: nil,
      provider_id: nil,
      token: nil
    }

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        avatar: "some avatar",
        email: "some email",
        name: "some name",
        provider: "some provider",
        provider_id: 42,
        token: "some token"
      }

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
  end
end
