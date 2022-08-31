defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias DiscussWeb.Router.Helpers, as: Routes

  # that is nothing to do in init function in this case
  # usually sets a default value for something (timezone for example)
  # runs only once
  def init(_) do
  end

  # the second argument of call function is the value returned by init
  # runs whenever a request arrives
  def call(conn, _) do
    if conn.assigns[:user] do
      conn
    else
      # Halts the Plug pipeline by preventing further plugs downstream from being invoked
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt
    end
  end
end
