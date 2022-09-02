defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  # first time communication
  # <> extracts the rest of the string and saves it in a variable, topic_id in this case
  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic = Topics.get_topic!(topic_id)
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # I was kind of in doubt with this handle_in
  # worth researching and studying more about it
  @impl true
  def handle_in(name, payload, socket) do
    case Topics.create_comment(payload, socket.assigns.topic, socket.assigns.user_id) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
