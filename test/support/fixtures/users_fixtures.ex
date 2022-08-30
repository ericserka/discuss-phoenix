defmodule Discuss.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Discuss.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        email: "some email",
        name: "some name",
        provider: "some provider",
        provider_id: 42,
        token: "some token"
      })
      |> Discuss.Users.create_user()

    user
  end
end
