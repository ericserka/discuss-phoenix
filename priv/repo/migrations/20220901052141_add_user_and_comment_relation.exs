defmodule Discuss.Repo.Migrations.AddUserAndCommentRelation do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :user_id, references(:users)
    end

    create index(:comments, [:user_id])
  end
end
