defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  # that is nothing to do in init function in this case
  # usually sets a default value for something (timezone for example)
  # runs only once
  def init(_) do
  end

  # the second argument of call function is the value returned by init
  # runs whenever a request arrives
  def call(conn, _) do
    case get_session(conn, :user) do
      nil ->
        assign(conn, :user, nil)

      user ->
        assign(conn, :user, user)
    end
  end
end
