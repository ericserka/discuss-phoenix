defmodule Discuss.Topics.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string
    belongs_to :topic, Discuss.Topics.Topic

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :topic_id])
    |> validate_required([:comment, :topic_id])
  end
end
