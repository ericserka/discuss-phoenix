defmodule Discuss.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string
      add :provider_id, :integer
      add :name, :string
      add :avatar, :string

      timestamps()
    end
  end
end
