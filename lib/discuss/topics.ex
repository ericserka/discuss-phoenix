defmodule Discuss.Topics do
  @moduledoc """
  The Topics context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo
  import Ecto
  alias Discuss.Topics.Topic
  alias Discuss.Topics.Comment

  @per_page 5

  @doc """
  Returns the per_page const.

  ## Examples

      iex> get_per_page()
      5

  """
  def get_per_page(), do: @per_page

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      {[%Topic{}, ...],1}

  """
  def list_topics(page) do
    {
      Topic
      |> order_by(:title)
      |> offset(^((page - 1) * @per_page))
      |> limit(@per_page)
      |> Repo.all(),
      Repo.aggregate(Topic, :count),
      page
    }
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic(123)
      %Topic{}

      iex> get_topic(456)
      nil

  """
  # select the topic by the id, get all the comments of that topic ordered by inserted_at and, for each comment, get the data of the user who made the comment
  def get_topic(id),
    do:
      Topic
      |> where(id: ^id)
      |> preload(comments: ^{Comment |> order_by(desc: :inserted_at), [:user]})
      |> Repo.one!()

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}, user) do
    # build_assoc insert user struct in topic struct for database persistence with association (user_id in topics table)
    build_assoc(user, :topics)
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{data: %Topic{}}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}, topic, user) do
    %Comment{topic: topic, user: user}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end
end
