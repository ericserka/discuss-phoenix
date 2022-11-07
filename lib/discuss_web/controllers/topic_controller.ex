defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  # scoped module plug
  plug DiscussWeb.Plugs.RequireAuth when action not in [:index, :index_redirect, :show]

  # function plug
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, %{"page" => page_param}) do
    {topics, total_elements, page} = Topics.list_topics(String.to_integer(page_param))
    per_page = Topics.get_per_page()
    total_pages = ceil(total_elements / per_page)
    from = (page - 1) * per_page + 1
    until = if page * per_page > total_elements, do: total_elements, else: page * per_page

    if page > total_pages do
      conn
      |> put_flash(:error, "Such page does not exist")
      |> redirect(to: Routes.topic_path(conn, :index))
    end

    render(conn, "index.html",
      topics: topics,
      total_elements: total_elements,
      page: page,
      total_pages: total_pages,
      x_data: "{currentPage: #{page}, pages: #{Jason.encode!(Enum.to_list(1..total_pages))}}",
      from: from,
      until: until,
      page_title: "All Topics"
    )
  end

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.topic_path(conn, :index, page: 1))
  end

  def index_redirect(conn, _) do
    conn
    |> redirect(to: Routes.topic_path(conn, :index, page: 1))
  end

  def new(conn, _params) do
    changeset = Topics.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset, page_title: "New Topic")
  end

  def create(conn, %{"topic" => topic_params}) do
    case Topics.create_topic(topic_params, conn.assigns.user) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "New Topic")
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      render(conn, "show.html", topic: topic, page_title: topic.title)
    else
      conn
      |> put_flash(:error, "Topic not found.")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Topics.get_topic(id)

    if topic != nil do
      render(conn, "edit.html",
        topic: topic,
        changeset: Topics.change_topic(topic),
        page_title: "Edit Topic"
      )
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
          render(conn, "edit.html", topic: topic, changeset: changeset, page_title: "Edit Topic")
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
        |> redirect(to: Routes.topic_path(conn, :index))
        |> halt
    end
  end
end
