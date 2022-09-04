defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  # scoped module plug
  plug DiscussWeb.Plugs.RequireAuth when action not in [:index, :show]

  # function plug
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, %{"current_page" => current_page}) do
    {topics, total, page} = Topics.list_topics(String.to_integer(current_page))
    render(conn, "index.html", topics: topics, total: total, page: page)
  end

  def index_redirect(conn, _) do
    conn
    |> redirect(to: Routes.topic_path(conn, :index, current_page: 1))
  end

  def new(conn, _params) do
    changeset = Topics.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Topics.create_topic(topic_params, conn.assigns.user) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      render(conn, "show.html", topic: topic)
    else
      conn
      |> put_flash(:error, "Topic not found.")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      render(conn, "edit.html", topic: topic, changeset: Topics.change_topic(topic))
    else
      conn
      |> put_flash(:error, "Topic not found.")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      case Topics.update_topic(topic, topic_params) do
        {:ok, topic} ->
          conn
          |> put_flash(:info, "Topic updated successfully.")
          |> redirect(to: Routes.topic_path(conn, :show, topic))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", topic: topic, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Topic not found.")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      Topics.delete_topic(topic)

      conn
      |> put_flash(:info, "Topic deleted successfully.")
      |> redirect(to: Routes.topic_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Topic not found.")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    topic = Topics.get_topic(topic_id)

    cond do
      topic == nil ->
        conn
        |> put_flash(:error, "Topic not found.")
        |> redirect(to: Routes.topic_path(conn, :index))

      topic.user_id == conn.assigns.user.id ->
        conn

      true ->
        conn
        |> put_flash(:error, "This topic does not belong to you.")
        |> redirect(to: "/")
        |> halt
    end
  end
end
