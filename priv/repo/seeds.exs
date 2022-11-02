# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Discuss.Repo.insert!(%Discuss.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Discuss.Repo
alias Discuss.Topics.Topic
alias Discuss.Users

{:ok, user} =
  Users.create_user(%{
    avatar: "shorturl.at/agOQ8",
    email: "email@email.com",
    name: "Some user name",
    provider: "github",
    provider_id: 42,
    token: "some token"
  })

Repo.insert_all(
  Topic,
  for i <- 1..100 do
    %{
      title: "my topic number #{i}",
      user_id: user.id,
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end
)
