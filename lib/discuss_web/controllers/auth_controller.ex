defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  plug Ueberauth

  alias Discuss.UserFromAuth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.return_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end
