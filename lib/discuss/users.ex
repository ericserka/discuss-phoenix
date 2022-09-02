defmodule Discuss.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Users.User

  @doc """
  Gets a user by list of clauses.

  ## Examples

      iex> get_user([provider: "github", provider_id: 123])
      %User{}

      iex> get_user([provider: "github", provider_id: 321])
      nil

  """
  def get_user(clauses), do: Repo.get_by(User, clauses)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
