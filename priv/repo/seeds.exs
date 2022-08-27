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

for comment <- ["Home Improvement", "Power Tools", "Gardening", "Books"] do
  {:ok, _} = Discuss.Topics.create_comment(%{comment: comment, topic_id: 2})
end
