# Phoenix Fullstack application

This application simulates a forum where comments can be added in real time for a given topic and related to a user.

It uses dependencies that allow login with GitHub (Ueberauth) and uses plugs to make the application safer and less susceptible to external attacks. Where the user can only perform certain actions if they are logged in or if they really own the topic, etc.

To create new OAuth Github App: `https://github.com/settings/developers`

Github Ueberauth Example Repository: https://github.com/ueberauth/ueberauth_example

## Useful mix commands for Phoenix framework

- mix phx.gen.channel: https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Channel.html#content
- mix phx.gen.socket: https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Socket.html
- mix phx.gen.context: https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Context.html
- mix phx.gen.html: https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Html.html
- mix phx.gen.schema: https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Schema.html
- mix ecto.gen.migration: https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Gen.Migration.html
- mix ecto.migrate: https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Migrate.html
- mix ecto.rollback: https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Rollback.html

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix