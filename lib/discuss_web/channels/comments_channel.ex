defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Topics

  # first time communication
  # <> extracts the rest of the string and saves it in a variable, topic_id in this case
  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic = Topics.get_topic(topic_id)
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # for each event that the client can push, I need a different handle_in
  # the one below handles the event of the user clicking to add a comment to the topic
  @impl true
  def handle_in("comments:add", payload, socket) do
    case Topics.create_comment(payload, socket.assigns.topic, socket.assigns.user) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
