defmodule Discuss.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :name, :string
    field :provider, :string
    field :provider_id, :integer
    field :token, :string
    has_many :topics, Discuss.Topics.Topic

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token, :provider_id, :name, :avatar])
    |> validate_required([:email, :provider, :token, :provider_id, :name, :avatar])
  end
end
