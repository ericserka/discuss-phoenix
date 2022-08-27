defmodule Discuss.TopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Discuss.Topics` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Discuss.Topics.create_topic()

    topic
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment: "some comment"
      })
      |> Discuss.Topics.create_comment()

    comment
  end
end
