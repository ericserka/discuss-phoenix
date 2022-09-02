defmodule Discuss.Topics.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  # used to transform elixir struct into json
  @derive {Jason.Encoder, only: [:comment, :user, :inserted_at]}

  schema "comments" do
    field :comment, :string
    belongs_to :topic, Discuss.Topics.Topic
    belongs_to :user, Discuss.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment])
    |> validate_required([:comment])
  end
end
