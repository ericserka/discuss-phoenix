defmodule Discuss.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  # used to transform elixir struct into json
  @derive {Jason.Encoder, only: [:avatar, :name]}

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :name, :string
    field :provider, :string
    field :provider_id, :integer
    field :token, :string
    has_many :topics, Discuss.Topics.Topic
    has_many :comments, Discuss.Topics.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token, :provider_id, :name, :avatar])
    |> validate_required([:email, :provider, :token, :provider_id, :name, :avatar])
  end
end
