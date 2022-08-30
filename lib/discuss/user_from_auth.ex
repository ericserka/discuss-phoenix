defmodule Discuss.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason

  alias Ueberauth.Auth
  alias Discuss.Users
  alias Discuss.Users.User

  def return_user(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        insert_or_update_user(auth)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def return_user(%Auth{} = auth) do
    insert_or_update_user(auth)
  end

  defp insert_or_update_user(auth) do
    case Users.get_user(provider: basic_info(auth).provider, provider_id: auth.uid) do
      nil ->
        Users.create_user(basic_info(auth))

      user ->
        {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    %{
      provider_id: auth.uid,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth),
      token: token_from_auth(auth),
      email: email_from_auth(auth),
      provider: provider_from_auth(auth)
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp token_from_auth(auth) do
    auth.credentials.token
  end

  defp email_from_auth(auth) do
    auth.info.email
  end

  defp provider_from_auth(auth) do
    Atom.to_string(auth.provider)
  end

  defp validate_pass(%{other: %{password: nil}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
