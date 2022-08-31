defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  alias Discuss.Users

  # that is nothing to do in init function in this case
  # usually sets a default value for something (timezone for example)
  # runs only once
  def init(_) do
  end

  # the second argument of call function is the value returned by init
  # runs whenever a request arrives
  def call(conn, _) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Users.get_user(id: user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
